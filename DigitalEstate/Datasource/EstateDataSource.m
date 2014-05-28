//
//  MockDataSource.m
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "EstateDataSource.h"
#import "LocalDataStrategy.h"
#import "DropboxDataStrategy.h"
#import "ConstantDefinition.h"

@implementation EstateDataSource

- (id) init
{
    if (self = [super init])
    {
//        _sortByLastUpdated = false;
        _observers = [[NSMutableArray alloc] init];
        
        [self updateDataStrategy];
        [self loadEstatesWithCompletionHandler:nil];
    }
    return self;
}

- (void)loadEstatesWithCompletionHandler:(void (^)(NSError* error))completionHandler
{
    NSArray* loadedData = [_dataStrategy loadEstateData];
    
    if (loadedData)
    {
        _estates = [NSMutableArray arrayWithArray:loadedData];
        if (completionHandler)
            completionHandler(nil);
        else
            [self fireDataChanged];
    }
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(EstateData*)estate
{
    [_estates replaceObjectAtIndex:index withObject:estate];    
    [self fireDataChanged];
    [_dataStrategy saveEstateData:_estates];
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    [_estates removeObjectAtIndex:index];
    [self fireDataChanged];
    [_dataStrategy saveEstateData:_estates];
}

- (void)removeObject:(EstateData*)estate
{
    [_estates removeObject:estate];
    [self fireDataChanged];
    [_dataStrategy saveEstateData:_estates];
}

- (void)addObject:(EstateData*)estate
{
    [_estates addObject:estate];
    [self fireDataChanged];
    [_dataStrategy saveEstateData:_estates];
}

- (void)insertObject:(EstateData*)estate atIndex:(NSUInteger)index
{
    [_estates insertObject:estate atIndex:index];
    [self fireDataChanged];
    [_dataStrategy saveEstateData:_estates];
}

- (NSUInteger)indexOfObject:(EstateData*)estate
{
    return [_estates indexOfObject:estate];
}

- (void)updateDataStrategy
{
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    
    NSString* type = [prefs stringForKey:kDatasourceType];
    
    if ([@"Dropbox" isEqualToString:type])
    {
        if (![_dataStrategy isKindOfClass:[DropboxDataStrategy class]])
        {
            DBAccount* account = [[DBAccountManager sharedManager] linkedAccount];
            if (account)
                [self setDataStrategy:[[DropboxDataStrategy alloc] init]];
        }
    }
    else
    {
        if (![_dataStrategy isKindOfClass:[LocalDataStrategy class]])
            [self setDataStrategy:[[LocalDataStrategy alloc] init]];
    }
}

- (void)estateDataLoaded:(NSArray*)datas
{
    if (datas == nil)
        return;
    
    //merge the data;
    for (EstateData* data in datas)
    {
        bool alreadyExist = false;
        for (EstateData* dataInView in _estates)
        {
            if ([dataInView.estateId isEqualToString:data.estateId])
            {
                alreadyExist = TRUE;
                if ([dataInView.lastUpdate compare:data.lastUpdate] == NSOrderedDescending)
                {
                    [self replaceObjectAtIndex:[_estates indexOfObject:dataInView] withObject:data];
                }
                break;
            }
        }
        if (!alreadyExist)
        {
            [self addObject:data];
        }
    }
}

#pragma mark setter

- (void)setDataStrategy:(id<DataStrategy>)dataStrategy
{
    if (dataStrategy == nil)
        return;
    
//    if (_dataStrategy != nil)
//    {
//        //try to merge, this takes a while
//            NSArray* datasInNewStrategy = [dataStrategy loadEstateData];
//            if (datasInNewStrategy)
//                for (EstateData* data in datasInNewStrategy)
//                {
//                    bool alreadyExist = false;
//                    for (EstateData* dataInView in _estates)
//                    {
//                        if ([dataInView.estateId isEqualToString:data.estateId])
//                        {
//                            alreadyExist = TRUE;
//                            if ([dataInView.lastUpdate compare:data.lastUpdate] == NSOrderedDescending)
//                            {
//                                [self replaceObjectAtIndex:[_estates indexOfObject:dataInView] withObject:data];
//                            }
//                            break;
//                        }
//                    }
//                    if (!alreadyExist)
//                    {
//                        [self addObject:data];
//                    }
//                }
//            [dataStrategy saveEstateData:_estates];
//        });
//    }

    _dataStrategy = dataStrategy;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadEstatesWithCompletionHandler:nil];
    });
}

#pragma mark Observable protocal

- (void)registerObserver:(id<Observer>)observer
{
    [_observers addObject:observer];
}

- (void)deregisterObserver:(id<Observer>)observer
{
    [_observers removeObject:observer];
}

- (void)fireDataChanged
{
    for (id<Observer> observer in _observers)
    {
        [observer dataChanged];
    }
}

@end
