//
//  CacheManager.m
//  auchinesemedia
//
//  Created by Yi Chen on 26/02/2014.
//  Copyright (c) 2014 ChenYi. All rights reserved.
//

#import "CacheManager.h"

@implementation CacheManager

+ (NSString *)applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+(NSArray*)loadFromCache:(NSArray*)keyArray WithExpireTime:(int)expireSecond
{
    NSString* keyName = [keyArray componentsJoinedByString:@"_"];
    
    if (expireSecond > 0)
    {
        double lastTime = [self getTimeWithKey:[NSString stringWithFormat:@"%@_Time",keyName]];
        double now = [[NSDate date] timeIntervalSinceReferenceDate];
        if (now - lastTime > expireSecond)//if cache is 4 hours old, ignore the cache.
        {
            return nil;
        }
    }
    
    NSString *dataPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:keyName];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    if (codedData == nil)
        return nil;
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    NSArray* entries = [unarchiver decodeObjectForKey:keyName];
    [unarchiver finishDecoding];
    
    return entries;
}

+ (double)getTimeWithKey:(NSString*)keyName
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSNumber* time = [prefs objectForKey:keyName];
    if (time == nil)
        return 0;
    return [time doubleValue];
}

+ (void)logTimeWithKey:(NSString*)keyName
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    double time = [[NSDate date] timeIntervalSinceReferenceDate];
    [prefs setObject:[NSNumber numberWithDouble:time] forKey:keyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveToCache:(NSArray*)cacheData withKey:(NSArray*)keyArray  {
    if (cacheData == nil) return;
    
    NSString* keyName = [keyArray componentsJoinedByString:@"_"];
    
    [self logTimeWithKey:[NSString stringWithFormat:@"%@_Time",keyName]];
    
    NSString *dataPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:keyName];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:cacheData forKey:keyName];
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];
}


@end
