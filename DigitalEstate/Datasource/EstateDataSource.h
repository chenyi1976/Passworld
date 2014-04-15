//
//  WebsiteDataSource.h
//  auchinesemedia
//
//  Created by Yi Chen on 13/02/2014.
//  Copyright (c) 2014 ChenYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EstateDataSource <NSObject>

- (NSArray*)getEntriesByType:(NSString*)type;

- (void)loadEntriesByType:(NSString*)type usingCache:(Boolean)usingCache withCompletionHandler:(void (^)(NSError* error))completionHandler;

- (void)setEntries:(NSArray*)entries ByType:(NSArray*)type;

@end
