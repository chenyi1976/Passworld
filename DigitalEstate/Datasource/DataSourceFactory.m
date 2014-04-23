//
//  DataSourceManager.m
//  auchinesemedia
//
//  Created by Yi Chen on 13/02/2014.
//  Copyright (c) 2014 ChenYi. All rights reserved.
//

#import "DataSourceFactory.h"
#import "MockDataSource.h"

@implementation DataSourceFactory

static Observable<EstateDataSource> *datasource = nil;

+ (Observable<EstateDataSource>*)getDataSource
{
    if (datasource == nil)
    {
        datasource = [[MockDataSource alloc] init];
    }
    return datasource;
}

@end
