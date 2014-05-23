//
//  DataSourceManager.m
//  auchinesemedia
//
//  Created by Yi Chen on 13/02/2014.
//  Copyright (c) 2014 ChenYi. All rights reserved.
//

#import "DataSourceFactory.h"
#import "LocalDataSource.h"
#import "DropboxDataSource.h"
#import "ConstantDefinition.h"

@implementation DataSourceFactory

static Observable<EstateDataSource> *datasource = nil;

+ (Observable<EstateDataSource>*)getDataSource
{
    if (datasource == nil)
    {
        NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
        
        NSString* type = [prefs stringForKey:kDatasourceType];
        if ([@"Dropbox" isEqualToString:type])
        {
            datasource = [[DropboxDataSource alloc] init];
        }
        else
        {
            datasource = [[LocalDataSource alloc] init];
        }
    }
    return datasource;
}

@end
