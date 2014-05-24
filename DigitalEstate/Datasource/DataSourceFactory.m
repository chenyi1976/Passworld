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
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(defaultsChanged:)
                                                     name:NSUserDefaultsDidChangeNotification
                                                   object:nil];
        
        datasource = [[EstateDataSource alloc] init];

        NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
        
        NSString* type = [prefs stringForKey:kDatasourceType];
        if ([@"Dropbox" isEqualToString:type])
        {
            if (![datasource.dataStrategy isKindOfClass:[DropboxDataStrategy class]])
                datasource.dataStrategy = [[DropboxDataStrategy alloc] init];
        }
        else
        {
            if (![datasource.dataStrategy isKindOfClass:[LocalDataStrategy class]])
                datasource.dataStrategy = [[LocalDataStrategy alloc] init];
        }
    }
    return datasource;
}

- (void)defaultsChanged:(NSNotification *) notification
{
    if (datasource)
    {
        NSUserDefaults *prefs = (NSUserDefaults *)[notification object];
        NSString* type = [prefs stringForKey:kDatasourceType];
        if ([@"Dropbox" isEqualToString:type])
        {
            if (![datasource.dataStrategy isKindOfClass:[DropboxDataStrategy class]])
                datasource.dataStrategy = [[DropboxDataStrategy alloc] init];
        }
        else
        {
            if (![datasource.dataStrategy isKindOfClass:[LocalDataStrategy class]])
                datasource.dataStrategy = [[LocalDataStrategy alloc] init];
        }
    }
}

@end
