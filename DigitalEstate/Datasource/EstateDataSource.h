//
//  WebsiteDataSource.h
//  auchinesemedia
//
//  Created by Yi Chen on 13/02/2014.
//  Copyright (c) 2014 ChenYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EstateData.h"

@protocol EstateDataSource <NSObject>

- (NSArray*)getEstates;

- (void)loadEstatesWithCompletionHandler:(void (^)(NSError* error))completionHandler;

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(EstateData*)estate;

- (void)removeObjectAtIndex:(NSUInteger)index;

- (void)addObject:(EstateData*)estate;

- (void)insertObject:(EstateData*)estate atIndex:(NSUInteger)index;

@end
