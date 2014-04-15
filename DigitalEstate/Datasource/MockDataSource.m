//
//  MockDataSource.m
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "MockDataSource.h"

@implementation MockDataSource

- (NSArray*)getEntriesByType:(NSString*)type
{
    return nil;
}

- (void)loadEntriesByType:(NSString*)type usingCache:(Boolean)usingCache withCompletionHandler:(void (^)(NSError* error))completionHandler
{
    return;
}

- (void)setEntries:(NSArray*)entries ByType:(NSArray*)type
{
    return;
}

@end
