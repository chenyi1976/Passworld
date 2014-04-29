//
//  MockDataSource.m
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "MockDataSource.h"
#import "CacheManager.h"
#import "AESCrypt.h"

@interface MockDataSource()
    @property NSMutableArray* estates;
@end

@implementation MockDataSource


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
    return _estates;
}

- (void)loadEstatesWithCompletionHandler:(void (^)(NSError* error))completionHandler
{
    NSArray* encryptEstates = [CacheManager loadFromCache:[NSArray arrayWithObject:@"estate"] WithExpireTime:0];
    NSArray* deepCopyArray = [[NSArray alloc] initWithArray:encryptEstates copyItems:TRUE];
    _estates = [NSMutableArray arrayWithArray:deepCopyArray];
    for (EstateData* data in _estates)
    {
        NSString *decryptedData = [AESCrypt decrypt:data.content password:@"password"];
        data.content = decryptedData;
    }
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(EstateData*)estate
{
    [_estates replaceObjectAtIndex:index withObject:estate];
    [self saveToCache];
    [super fireDataChanged];
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    [_estates removeObjectAtIndex:index];
    [self saveToCache];
    [super fireDataChanged];
    
}

- (void)removeObject:(EstateData*)estate
{
    [_estates removeObject:estate];
    [self saveToCache];
    [super fireDataChanged];
}

- (void)addObject:(EstateData*)estate
{
    [_estates addObject:estate];
    [self saveToCache];
    [super fireDataChanged];
}

- (void)insertObject:(EstateData*)estate atIndex:(NSUInteger)index
{
    [_estates insertObject:estate atIndex:index];
    [self saveToCache];
    [super fireDataChanged];
}

- (NSUInteger)indexOfObject:(EstateData*)estate
{
    return [_estates indexOfObject:estate];
}

#pragma mark private method

- (void)saveToCache
{
    NSArray* encryptEstates = [[NSArray alloc] initWithArray:_estates copyItems:TRUE];
    for (EstateData* data in encryptEstates)
    {
        NSString *encryptedData = [AESCrypt encrypt:data.content password:@"password"];
        data.content = encryptedData;
    }
    [CacheManager saveToCache:encryptEstates withKey:[NSArray arrayWithObject:@"estate"]];
}

@end
