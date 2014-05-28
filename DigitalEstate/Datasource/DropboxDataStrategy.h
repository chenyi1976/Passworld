//
//  DropboxDataStrategy.h
//  DigitalEstate
//
//  Created by Yi Chen on 25/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataStrategy.h"
#import "Dropbox/Dropbox.h"
#import "EstateDataSource.h"

#define kEstateTable @"OPPS"
#define kFieldData @"data"
#define kFieldLastUpdate @"lastUpdated"

@interface DropboxDataStrategy : NSObject<DataStrategy>

@property (retain) DBDatastore *store;
@property (retain) EstateDataSource *datasource;

- (id)initWithDataSource:(EstateDataSource*)datasource;

@end
