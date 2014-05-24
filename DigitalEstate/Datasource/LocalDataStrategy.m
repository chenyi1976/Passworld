//
//  LocalDataStrategy.m
//  DigitalEstate
//
//  Created by Yi Chen on 25/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "LocalDataStrategy.h"
#import "CacheManager.h"
#import "AESCrypt.h"
#import "ConstantDefinition.h"
#import "KeyChainUtil.h"
#import "AttributeData.h"

@implementation LocalDataStrategy

- (NSArray*)loadEstateData
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
            if (data.attributeValues)
            {
                NSMutableArray* newAttributeValues = [[NSMutableArray alloc] init];
                for (AttributeData* attributeData in data.attributeValues)
                {
                    if (attributeData)
                    {
                        NSString *decryptedAttrName = [AESCrypt decrypt:attributeData.attrName password:encryptKey];
                        NSString *decryptedAttrValue = [AESCrypt decrypt:attributeData.attrValue password:encryptKey];
                        [newAttributeValues addObject:[[AttributeData alloc] initWithId:attributeData.attrId name:decryptedAttrName value:decryptedAttrValue]];
                    }
                }
                data.attributeValues = newAttributeValues;
            }
        }
    }
    
    //    if (_sortByLastUpdated)
    //    {
    //        _estates = [NSMutableArray arrayWithArray:[deepCopyArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
    //            NSDate *first = [(EstateData*)a lastUpdate];
    //            NSDate *second = [(EstateData*)b lastUpdate];
    //            return [first compare:second];
    //        }]];
    //    }
    //    else
    //    {
    return [NSMutableArray arrayWithArray:deepCopyArray];
    //    }
}


- (void)saveEstateData:(NSArray*) estateDataArray
{
    [self saveToCache:estateDataArray];
}

#pragma mark private method

- (void)saveToCache:(NSArray*) estateDataArray
{
    NSArray* encryptEstates = [[NSArray alloc] initWithArray:estateDataArray copyItems:TRUE];
    NSString* encryptKey = [self getEncryptKey];
    if (encryptKey)
    {
        for (EstateData* data in encryptEstates)
        {
            NSString *encryptedData = [AESCrypt encrypt:data.content password:encryptKey];
            data.content = encryptedData;
            if (data.attributeValues)
            {
                NSMutableArray* newAttributeValues = [[NSMutableArray alloc] init];
                for (AttributeData* attributeData in data.attributeValues)
                {
                    if (attributeData)
                    {
                        NSString *encryptedAttrName = [AESCrypt encrypt:attributeData.attrName password:encryptKey];
                        NSString *encryptedAttrValue = [AESCrypt encrypt:attributeData.attrValue password:encryptKey];
                        [newAttributeValues addObject:[[AttributeData alloc] initWithId:attributeData.attrId name:encryptedAttrName value:encryptedAttrValue]];
                    }
                }
                data.attributeValues = newAttributeValues;
            }
            
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
