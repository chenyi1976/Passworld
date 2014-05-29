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
        _estates = [[NSMutableArray alloc] init];
        
        [self updateDataStrategy];
        [self loadEstatesWithCompletionHandler:nil];
    }
    return self;
}

- (void)loadEstatesWithCompletionHandler:(void (^)(NSError* error))completionHandler
{
    NSArray* loadedData = [_dataStrategy loadEstateData];
    
    [self estateDataLoaded:loadedData];
    if (completionHandler)
        completionHandler(nil);
    else
        [self fireDataChanged];
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
                [self setDataStrategy:[[DropboxDataStrategy alloc] initWithDataSource:self]];
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
    //if loaded datas is nil, then try to see if we need to save existing data.
    if (datas == nil)
    {
        if (_estates != nil && [_estates count] > 0)
        {
            [_dataStrategy saveEstateData:_estates];
        }
        return;
    }
    
    //merge the data
    bool changed = false;
    for (EstateData* data in datas)
    {
        //if _estates has a new version of the loaded data, then no need to update _estates with the loaded data.
        bool alreadyExist = false;
        for (EstateData* dataInView in _estates)
        {
            if ([dataInView.estateId isEqualToString:data.estateId])
            {
                alreadyExist = true;
                if ([dataInView.lastUpdate compare:data.lastUpdate] == NSOrderedDescending)
                {
                    [_estates replaceObjectAtIndex:[_estates indexOfObject:dataInView] withObject:data];
                    changed = true;
                }
                break;
            }
        }
        if (!alreadyExist)
        {
            [_estates addObject:data];
            changed = true;
        }
    }
    
    //if merged result is different with the loaded data, then save it back.
    if (![_estates isEqualToArray:datas])
    {
        [_dataStrategy saveEstateData:_estates];
    }
    
    //if merged result changed _estates, then refresh UITableView
    if (changed)
    {
        [self fireDataChanged];
    }
}

#pragma mark setter

- (void)setDataStrategy:(id<DataStrategy>)dataStrategy
{
    if (dataStrategy == nil)
        return;

    _dataStrategy = dataStrategy;
    
    //load data from new data strategy with a thread.
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
