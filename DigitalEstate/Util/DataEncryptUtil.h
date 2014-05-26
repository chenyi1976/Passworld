//
//  DataEncryptUtil.h
//  DigitalEstate
//
//  Created by Yi Chen on 25/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataEncryptUtil : NSObject

+ (NSData*)encryptData:(NSArray*)estateDatas;
+ (NSArray*)decryptData:(NSData*)dataStr;


@end
