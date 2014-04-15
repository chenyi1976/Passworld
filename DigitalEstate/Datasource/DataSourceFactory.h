//
//  DataSourceManager.h
//  auchinesemedia
//
//  Created by Yi Chen on 13/02/2014.
//  Copyright (c) 2014 ChenYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EstateDataSource.h"

#define kMockKey @"mockDataSource"

@interface DataSourceFactory : NSObject

+ (DataSourceFactory*)sharedInstance;

- (void)registerDataSource:(id<EstateDataSource>)datasource forName:(NSString*)name;
- (id<EstateDataSource>)getDataSource:(NSString*)name;

@end
