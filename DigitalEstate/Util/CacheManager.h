//
//  CacheManager.h
//  auchinesemedia
//
//  Created by Yi Chen on 26/02/2014.
//  Copyright (c) 2014 ChenYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject

+(NSArray*)loadFromCache:(NSArray*)keyArray WithExpireTime:(int)expireSecond;
+(void)saveToCache:(NSArray*)cacheData withKey:(NSArray*)keyArray;

@end
