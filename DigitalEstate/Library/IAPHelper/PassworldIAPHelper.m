//
//  PassworldIAPHelper.m
//  DigitalEstate
//
//  Created by ChenYi on 15/04/2015.
//  Copyright (c) 2015 Yi Chen. All rights reserved.
//

#import "PassworldIAPHelper.h"
#import "ConstantDefinition.h"

@implementation PassworldIAPHelper

+ (PassworldIAPHelper *)sharedInstance{
    static dispatch_once_t once;
    static PassworldIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      iap_id_pro,
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
