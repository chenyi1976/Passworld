//
//  DataSourceManager.m
//  auchinesemedia
//
//  Created by Yi Chen on 13/02/2014.
//  Copyright (c) 2014 ChenYi. All rights reserved.
//

#import "DataSourceFactory.h"
#import "ConstantDefinition.h"
#import "DropboxDataStrategy.h"
#import "LocalDataStrategy.h"

@implementation DataSourceFactory

static EstateDataSource *datasource = nil;

+ (EstateDataSource*)getDataSource
{
    if (datasource == nil)
    {
        datasource = [[EstateDataSource alloc] init];
    }
    return datasource;
}

@end
