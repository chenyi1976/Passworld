//
//  DataEncryptUtil.m
//  DigitalEstate
//
//  Created by Yi Chen on 25/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "DataEncryptUtil.h"
#import "KeyChainUtil.h"
#import "EstateData.h"
#import "ConstantDefinition.h"
#import "AESCrypt.h"
#import "AttributeData.h"

@implementation DataEncryptUtil

+ (NSArray*)encryptData:(NSArray*)data
{
    NSString* encryptKey = [KeyChainUtil loadFromKeyChainForKey:kEncryptKey];
    if (encryptKey == nil)
        return data;
    
    if (data == nil)
        return data;
    
    if ([data count] == 0)
        return data;

    NSArray* encryptEstates = [[NSArray alloc] initWithArray:data copyItems:TRUE];
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

    return encryptEstates;
}

+ (NSArray*)decryptData:(NSArray*)data
{
    NSString* encryptKey = [KeyChainUtil loadFromKeyChainForKey:kEncryptKey];
    if (encryptKey == nil)
        return data;
    
    if (data == nil)
        return data;
    
    if ([data count] == 0)
        return data;
    
    NSArray* decryptEstates = [[NSArray alloc] initWithArray:data copyItems:TRUE];
    for (EstateData* data in decryptEstates)
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
                    NSString *encryptedAttrName = [AESCrypt decrypt:attributeData.attrName password:encryptKey];
                    NSString *encryptedAttrValue = [AESCrypt decrypt:attributeData.attrValue password:encryptKey];
                    [newAttributeValues addObject:[[AttributeData alloc] initWithId:attributeData.attrId name:encryptedAttrName value:encryptedAttrValue]];
                }
            }
            data.attributeValues = newAttributeValues;
        }
        
    }
    
    return decryptEstates;
}

@end
