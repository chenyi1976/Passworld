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

- (void)setEstate:(EstateData*)estate ForIndex:(int)index;

@end
