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
    if (encryptEstates == nil || encryptEstates.count == 0)
        return encryptEstates;

    NSData* data = [encryptEstates objectAtIndex:0];
    NSArray* decryptEstates = [DataEncryptUtil decryptData:data];
    
    return decryptEstates;
}


- (void)saveEstateData:(NSArray*) estateDataArray
{
    NSData* data = [DataEncryptUtil encryptData:estateDataArray];
    if (data == nil)
    {
        NSLog(@"LocalDataStrategy saveEstatateData: data is nil");
        return;
    }
    [CacheManager saveToCache:[NSArray arrayWithObject:data] withKey:[NSArray arrayWithObject:kEstate]];
}


@end
