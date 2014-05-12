//
//  KeyChainUtil.h
//  DigitalEstate
//
//  Created by Yi Chen on 12/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainUtil : NSObject

+ (bool)saveToKeyChainForKey:(NSString*) key withValue:(NSString*) value;
+ (NSString*)loadFromKeyChainForKey:(NSString*) key;


@end
