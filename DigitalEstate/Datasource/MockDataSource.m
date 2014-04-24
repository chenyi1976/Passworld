//
//  MockDataSource.m
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "MockDataSource.h"
#import "CacheManager.h"

@implementation MockDataSource

NSMutableArray* estates = nil;

- (id) init
{
    if (self = [super init])
    {
        [self loadEstatesWithCompletionHandler:nil];
    }
    return self;
}


- (NSMutableArray*)getEstates
{
    return estates;
}

- (void)loadEstatesWithCompletionHandler:(void (^)(NSError* error))completionHandler
{
    estates = [NSMutableArray arrayWithArray:[CacheManager loadFromCache:[NSArray arrayWithObject:@"estate"] WithExpireTime:0]];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(EstateData*)estate
{
    [estates replaceObjectAtIndex:index withObject:estate];
    [super fireDataChanged];
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    [estates removeObjectAtIndex:index];
    [CacheManager saveToCache:estates withKey:[NSArray arrayWithObject:@"estate"]];
    [super fireDataChanged];
    
}

- (void)removeObject:(EstateData*)estate
{
    [estates removeObject:estate];
    [CacheManager saveToCache:estates withKey:[NSArray arrayWithObject:@"estate"]];
    [super fireDataChanged];
}

- (void)addObject:(EstateData*)estate
{
    [estates addObject:estate];
    [CacheManager saveToCache:estates withKey:[NSArray arrayWithObject:@"estate"]];
    [super fireDataChanged];
}

- (void)insertObject:(EstateData*)estate atIndex:(NSUInteger)index
{
    [estates insertObject:estate atIndex:index];
    [CacheManager saveToCache:estates withKey:[NSArray arrayWithObject:@"estate"]];
    [super fireDataChanged];
}

- (NSUInteger)indexOfObject:(EstateData*)estate
{
    return [estates indexOfObject:estate];
}

@end
