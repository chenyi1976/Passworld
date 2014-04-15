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

NSMutableDictionary* datasourceDict = nil;

static DataSourceFactory* instance = nil;

+ (DataSourceFactory*)sharedInstance
{
    if (instance == nil)
    {
        instance = [[DataSourceFactory alloc] init];
        [instance registerDataSource:[[MockDataSource alloc] init] forName:kMockKey];
    }
    return instance;
}

- (void)registerDataSource:(id<EstateDataSource>)datasource forName:(NSString*)name
{
    if (datasourceDict == nil)
        datasourceDict = [[NSMutableDictionary alloc] init];
    [datasourceDict setValue:datasource forKey:name];
}

- (id<EstateDataSource>)getDataSource:(NSString*)name;
{
    if (datasourceDict == nil)
        return nil;
    
    return [datasourceDict valueForKey:name];
}

@end
