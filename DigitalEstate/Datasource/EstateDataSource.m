//
//  MockDataSource.m
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "EstateDataSource.h"
#import "LocalDataStrategy.h"

@implementation EstateDataSource

- (id) init
{
    if (self = [super init])
    {
//        _sortByLastUpdated = false;
        _observers = [[NSMutableArray alloc] init];
        [self loadEstatesWithCompletionHandler:nil];
        _dataStrategy = [[LocalDataStrategy alloc] init];
    }
    return self;
}

- (void)loadEstatesWithCompletionHandler:(void (^)(NSError* error))completionHandler
{
    _estates = [NSMutableArray arrayWithArray:[_dataStrategy loadEstateData]];
    if (completionHandler)
        completionHandler(nil);
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

#pragma mark setter

- (void)setDataStrategy:(id<DataStrategy>)dataStrategy
{
    if (dataStrategy == nil)
        return;
    
    if (_dataStrategy != nil)
    {
        //try to save data, if this is a data strategy switch (not first time init).
        [dataStrategy saveEstateData:_estates];
    }

    _dataStrategy = dataStrategy;
    
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
