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
#import "ConstantDefinition.h"
#import "KeyChainUtil.h"

@interface MockDataSource()
    @property NSMutableArray* estates;
@end

@implementation MockDataSource


- (id) init
{
    if (self = [super init])
    {
        _sortByLastUpdated = true;
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
    NSArray* encryptEstates = [CacheManager loadFromCache:[NSArray arrayWithObject:kEstate] WithExpireTime:0];
    NSArray* deepCopyArray = [[NSArray alloc] initWithArray:encryptEstates copyItems:TRUE];
    
    NSString* encryptKey = [self getEncryptKey];
    if (encryptKey)
    {
        for (EstateData* data in deepCopyArray)
        {
            NSString *decryptedData = [AESCrypt decrypt:data.content password:encryptKey];
            data.content = decryptedData;
        }
    }
    
    if (_sortByLastUpdated)
    {
        _estates = [NSMutableArray arrayWithArray:[deepCopyArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSDate *first = [(EstateData*)a lastUpdate];
            NSDate *second = [(EstateData*)b lastUpdate];
            return [first compare:second];
        }]];
    }
    else
    {
        _estates = [NSMutableArray arrayWithArray:deepCopyArray];
    }
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(EstateData*)estate
{
    if (!_sortByLastUpdated)
        [_estates replaceObjectAtIndex:index withObject:estate];
    else
    {
        [_estates removeObjectAtIndex:index];
        [_estates addObject:estate];
    }
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
    if (!_sortByLastUpdated)
        [_estates insertObject:estate atIndex:index];
    else
        [_estates addObject:estate];
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
    NSString* encryptKey = [self getEncryptKey];
    if (encryptKey)
    {
        for (EstateData* data in encryptEstates)
        {
            NSString *encryptedData = [AESCrypt encrypt:data.content password:encryptKey];
            data.content = encryptedData;
        }
    }
    [CacheManager saveToCache:encryptEstates withKey:[NSArray arrayWithObject:kEstate]];
}

- (NSString*)getEncryptKey
{
    NSString* key = [KeyChainUtil loadFromKeyChainForKey:kEncryptKey];
//    if (!key)
//        key = @"password";
    return key;
}

@end
