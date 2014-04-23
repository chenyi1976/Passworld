//
//  MockDataSource.m
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "MockDataSource.h"

@implementation MockDataSource

NSMutableArray* estates = nil;

- (id) init
{
    if (self = [super init])
    {
        estates = [[NSMutableArray alloc] init];
        [estates addObject:[[EstateData alloc] initWithName:@"Estate1" Content:@"Content1"]];
    }
    return self;
}


- (NSMutableArray*)getEstates
{
    return estates;
}

- (void)loadEstatesWithCompletionHandler:(void (^)(NSError* error))completionHandler
{
    
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(EstateData*)estate
{
    [estates replaceObjectAtIndex:index withObject:estate];
    [super fireDataChanged];
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    [estates removeObjectAtIndex:index];
    [super fireDataChanged];
}

- (void)removeObject:(EstateData*)estate
{
    [estates removeObject:estate];
    [super fireDataChanged];
}

- (void)addObject:(EstateData*)estate
{
    [estates addObject:estate];
    [super fireDataChanged];
}

- (void)insertObject:(EstateData*)estate atIndex:(NSUInteger)index
{
    [estates insertObject:estate atIndex:index];
    [super fireDataChanged];
}

- (NSUInteger)indexOfObject:(EstateData*)estate
{
    return [estates indexOfObject:estate];
}

@end
