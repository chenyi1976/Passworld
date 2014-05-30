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
        _deletedEstates = [[NSMutableArray alloc] init];
        
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
//    else
//        [self fireDataChanged];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(EstateData*)estate
{
    [_estates replaceObjectAtIndex:index withObject:estate];    
    [self fireDataChanged];
    [_dataStrategy saveEstateData:_estates withDeletedData:_deletedEstates];
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    EstateData* estate = [_estates objectAtIndex:index];
    estate.deleted = true;
    [_deletedEstates addObject:estate];
    [_estates removeObjectAtIndex:index];
    [self fireDataChanged];
    [_dataStrategy saveEstateData:_estates withDeletedData:_deletedEstates];
}

- (void)removeObject:(EstateData*)estate
{
    [_estates removeObject:estate];
    estate.deleted = true;
    [_deletedEstates addObject:estate];
    [self fireDataChanged];
    [_dataStrategy saveEstateData:_estates withDeletedData:_deletedEstates];
}

- (void)addObject:(EstateData*)estate
{
    [_estates addObject:estate];
    [self fireDataChanged];
    [_dataStrategy saveEstateData:_estates withDeletedData:_deletedEstates];
}

- (void)insertObject:(EstateData*)estate atIndex:(NSUInteger)index
{
    [_estates insertObject:estate atIndex:index];
    [self fireDataChanged];
    [_dataStrategy saveEstateData:_estates withDeletedData:_deletedEstates];
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
            [_dataStrategy saveEstateData:_estates withDeletedData:_deletedEstates];
        }
        return;
    }
    
    //this is used to find data not in loaded data.
    NSMutableArray* localOnlyDatas = [[NSMutableArray alloc] initWithArray:_estates];
    [localOnlyDatas addObjectsFromArray:_deletedEstates];
    
    //merge the data
    bool changed = false;
    for (EstateData* data in datas)
    {
        NSArray* nmEstates = [[NSArray alloc] initWithArray:_estates];
        bool alreadyFound = false;
        for (EstateData* dataInView in nmEstates)
        {
            //if _estates has a new version of the loaded data, then no need to update _estates with the loaded data.
            if ([dataInView.estateId isEqualToString:data.estateId])
            {
                alreadyFound = true;
                [localOnlyDatas removeObject:dataInView];
                
                if (data.deleted)
                {
                    [_estates removeObject:dataInView];
                    //maybe need to check if the data is already in _deletedEstates or not,
                    //but it does not matter too much.
                    if ([dataInView.lastUpdate compare:data.lastUpdate] == NSOrderedDescending)
                        [_deletedEstates addObject:data];
                    else
                    {
                        [dataInView setSynced:![_dataStrategy isLocal]];
                        [_deletedEstates addObject:dataInView];
                    }
                }
                else
                {
                    if ([dataInView.lastUpdate compare:data.lastUpdate] == NSOrderedDescending)
                    {
                        [_estates replaceObjectAtIndex:[_estates indexOfObject:dataInView] withObject:data];
                        changed = true;
                    }
                    else
                    {
                        [dataInView setSynced:![_dataStrategy isLocal]];
                    }
                }
                break;
            }
        }
        if (!alreadyFound)
        {
            NSArray* nmDeletedEstates = [[NSArray alloc] initWithArray:_deletedEstates];
            for (EstateData* dataInBin in nmDeletedEstates)
            {
                if ([dataInBin.estateId isEqualToString:data.estateId])
                {
                    alreadyFound = true;
                    [localOnlyDatas removeObject:dataInBin];
                    
                    if (!data.deleted)
                    {
                        [_deletedEstates removeObject:dataInBin];
                        if ([dataInBin.lastUpdate compare:data.lastUpdate] == NSOrderedDescending)
                            [_estates addObject:data];
                        else
                        {
                            [dataInBin setSynced:![_dataStrategy isLocal]];
                            [_estates addObject:dataInBin];
                        }
                    }
                    else
                    {
                        if ([dataInBin.lastUpdate compare:data.lastUpdate] == NSOrderedDescending)
                        {
                            [_estates replaceObjectAtIndex:[_estates indexOfObject:dataInBin] withObject:data];
                            changed = true;
                        }
                        else
                        {
                            [dataInBin setSynced:![_dataStrategy isLocal]];
                        }
                    }
                    break;
                }
            }
        }
        if (!alreadyFound)
        {
            if (data.deleted)
                [_deletedEstates addObject:data];
            else
                [_estates addObject:data];
            changed = true;
        }
    }
    
    if (![_dataStrategy isLocal])
        if ([localOnlyDatas count] > 0)
        {
            for (EstateData* data in localOnlyDatas)
            {
                if (data.synced)
                {
                    if ([_estates containsObject:data])
                    {
                        [_estates removeObject:data];
                        changed = true;
                    }
                    else if ([_deletedEstates containsObject:data])
                    {
                        [_deletedEstates removeObject:data];
                    }
                }
            }
        }
    
    //if merged result is different with the loaded data, then save it back.
    bool needToSaveBack = false;
    NSMutableArray* allDatas = [[NSMutableArray alloc] initWithArray:_estates];
    [allDatas addObjectsFromArray:_deletedEstates];
    
    if ([allDatas count] != [datas count])
    {
        needToSaveBack = true;
    }
    else
    {
        for (int i = 0; i < [allDatas count]; i ++)
        {
            EstateData* data = [allDatas objectAtIndex:i];
            EstateData* loadedData = [datas objectAtIndex:i];
            
            if (![data.estateId isEqualToString:loadedData.estateId])
            {
                needToSaveBack = true;
                break;
            }
        }
    }
    if (needToSaveBack)
        [_dataStrategy saveEstateData:_estates withDeletedData:_deletedEstates];

    
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
//    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadEstatesWithCompletionHandler:nil];
//    });
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
