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

+ (NSData*)encryptData:(NSArray*)estateDatas
{
    if (estateDatas == nil)
        return nil;
    
    if ([estateDatas count] == 0)
        return nil;
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:estateDatas];
    
    NSString* encryptKey = [KeyChainUtil loadFromKeyChainForKey:kEncryptKey];
    if (encryptKey != nil)
    {
        data = [AESCrypt encryptData:data password:encryptKey];
//        data = [encryptedStr dataUsingEncoding:NSUTF8StringEncoding];
//        NSString* decryptedStr = [AESCrypt decrypt:encryptedStr password:encryptKey];
//        NSLog(@"%@\n%@", encryptedStr, decryptedStr);
    }
    
    return data;
}

+ (NSArray*)decryptData:(NSData*)data
{
    if (data == nil)
        return nil;
    
    NSString* encryptKey = [KeyChainUtil loadFromKeyChainForKey:kEncryptKey];
    if (encryptKey != nil)
    {
        data = [AESCrypt decryptData:data password:encryptKey];
//        data = [decryptedStr dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    if (data == nil)
        return nil;
    
    @try {
        NSArray* estateDataArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return estateDataArray;
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
    }
    return nil;
}



@end
