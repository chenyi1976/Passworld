//
//  MockDataSource.m
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "MockDataSource.h"

@implementation MockDataSource

- (NSArray*)getEstates
{
    return [NSArray arrayWithObjects:[[EstateData alloc] initWithName:@"Estate1" Content:@"Content1"], nil];
}

- (void)loadEstatesWithCompletionHandler:(void (^)(NSError* error))completionHandler
{
    
}

- (void)setEstate:(EstateData*)estate ForIndex:(int)index
{
    
}

@end
