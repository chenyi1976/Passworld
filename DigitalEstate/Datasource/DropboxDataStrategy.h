//
//  DropboxDataStrategy.h
//  DigitalEstate
//
//  Created by Yi Chen on 25/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataStrategy.h"
//#import <DropboxSDK/DropboxSDK.h>
#import "EstateDataSource.h"

#define kEstateTable @"O_P_P_S"
#define kFieldData @"data"
#define kFieldLastUpdate @"lastUpdated"

@interface DropboxDataStrategy : NSObject<DataStrategy>

//@property (retain) DBSession *store;
@property (retain) EstateDataSource *datasource;

- (id)initWithDataSource:(EstateDataSource*)datasource;

@end
