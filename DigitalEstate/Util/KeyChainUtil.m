//
//  KeyChainUtil.m
//  DigitalEstate
//
//  Created by Yi Chen on 12/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "KeyChainUtil.h"

@implementation KeyChainUtil

+ (bool)saveToKeyChainForKey:(NSString*) key withValue:(NSString*) value
{
    NSString* existingValue = [self loadFromKeyChainForKey:key];
    if (existingValue)
    {
        return [self updateKeyChainForKey:key withValue:value];
    }
    else
    {
        return [self addToKeyChainForKey:key withValue:value];
    }
}


+ (bool)addToKeyChainForKey:(NSString*) key withValue:(NSString*) value
{
    NSData* valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
    NSString* service = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary* secItem = @{
                              (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                              (__bridge id)kSecAttrService: service,
                              (__bridge id)kSecAttrAccount: key,
                              (__bridge id)kSecValueData: valueData,
                              (__bridge id)kSecAttrSynchronizable: (__bridge id)kCFBooleanTrue
                              };
    
    CFTypeRef result = NULL;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)secItem, &result);
    if (status == errSecSuccess)
    {
        NSLog(@"Successfully stored the encrypt key");
        return true;
    }
    else
    {
        NSLog(@"Failed to store the encrypt key with code: %ld", (long)status);
        return false;
    }
}

+ (bool)updateKeyChainForKey:(NSString*) key withValue:(NSString*) value
{
    NSData* valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
    NSString* service = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary* secItem = @{
                              (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                              (__bridge id)kSecAttrService: service,
                              (__bridge id)kSecAttrAccount: key,
                              (__bridge id)kSecAttrSynchronizable: (__bridge id)kCFBooleanTrue
                              };
    NSDictionary* update = @{
                             (__bridge id)kSecValueData: valueData
                             };
    
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)secItem, (__bridge CFDictionaryRef)update);
    if (status == errSecSuccess)
    {
        NSLog(@"Successfully update the encrypt key");
        return true;
    }
    else
    {
        NSLog(@"Failed to update the encrypt key with code: %ld", (long)status);
        return false;
    }
}

+ (NSString*)loadFromKeyChainForKey:(NSString*) key
{
    NSString* service = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary* query = @{
                              (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                              (__bridge id)kSecAttrService: service,
                              (__bridge id)kSecAttrAccount: key,
                              (__bridge id)kSecReturnData: (__bridge id)kCFBooleanTrue,
                              (__bridge id)kSecAttrSynchronizable: (__bridge id)kCFBooleanTrue
                              };
    
    CFDataRef cfValue = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&cfValue);
    if (status == errSecSuccess)
    {
        NSString* value = [[NSString alloc] initWithData:(__bridge_transfer NSData*)cfValue encoding:NSUTF8StringEncoding];
        NSLog(@"Successfully get the encrypt key");
        return value;
    }
    else
    {
        NSLog(@"Failed to query the encrypt key with code: %ld", (long)status);
        return nil;
    }
}

@end
