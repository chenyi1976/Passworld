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
#import "DataEncryptUtil.h"

@implementation LocalDataStrategy

- (NSArray*)loadEstateData
{
    NSArray* encryptEstates = [CacheManager loadFromCache:[NSArray arrayWithObject:kEstate] WithExpireTime:0];
    NSArray* decryptEstates = [DataEncryptUtil decryptData:encryptEstates];

    return [NSMutableArray arrayWithArray:decryptEstates];
}


- (void)saveEstateData:(NSArray*) estateDataArray
{
    NSArray* encryptEstates = [DataEncryptUtil encryptData:estateDataArray];
    [CacheManager saveToCache:encryptEstates withKey:[NSArray arrayWithObject:kEstate]];
}


@end
