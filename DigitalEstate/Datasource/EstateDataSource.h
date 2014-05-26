//
//  WebsiteDataSource.h
//  auchinesemedia
//
//  Created by Yi Chen on 13/02/2014.
//  Copyright (c) 2014 ChenYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EstateData.h"
#import "Observable.h"
#import "DataStrategy.h"

@interface EstateDataSource:NSObject<Observable>

@property bool sortByLastUpdated;
@property NSMutableArray* observers;
@property NSMutableArray* estates;
@property NSMutableArray* deletedEstates;
@property(nonatomic) id<DataStrategy> dataStrategy;

- (void)loadEstatesWithCompletionHandler:(void (^)(NSError* error))completionHandler;

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(EstateData*)estate;

- (void)removeObjectAtIndex:(NSUInteger)index;

- (void)removeObject:(EstateData*)estate;

- (void)addObject:(EstateData*)estate;

- (void)insertObject:(EstateData*)estate atIndex:(NSUInteger)index;

- (NSUInteger)indexOfObject:(EstateData*)estate;

- (void)updateDataStrategy;

@end
