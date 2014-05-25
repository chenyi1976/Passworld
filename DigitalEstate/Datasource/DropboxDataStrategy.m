//
//  DropboxDataStrategy.m
//  DigitalEstate
//
//  Created by Yi Chen on 25/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "DropboxDataStrategy.h"
#import "KeyChainUtil.h"
#import "ConstantDefinition.h"
#import "AESCrypt.h"
#import "AttributeData.h"
#import "DataEncryptUtil.h"

@implementation DropboxDataStrategy

- (id) init
{
    if (self = [super init])
    {
        DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
        _store = [DBDatastore openDefaultStoreForAccount:account error:nil];
    }
    return self;
}


- (NSArray*)loadEstateData
{
    DBTable *estateTable = [self.store getTable:@"estate"];
    NSArray *recordArray = [estateTable query:@{ @"deleted": @NO } error:nil];

    //todo: need to reorder the query result first
    
    NSMutableArray* estateDataArray = [[NSMutableArray alloc] init];
    for (DBRecord* record in recordArray)
    {
        NSData* data = record[@"data"];
        EstateData* estateData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [estateDataArray addObject:estateData];
    }

    NSArray* decryptEstates = [DataEncryptUtil encryptData:estateDataArray];
    return decryptEstates;
}

- (void)saveEstateData:(NSArray*) estateDataArray
{
    DBTable *estateTable = [self.store getTable:@"estate"];
    
    NSArray* encryptEstates = [DataEncryptUtil encryptData:estateDataArray];

    for (EstateData* estateData in encryptEstates)
    {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:estateData];
        
        NSArray *results = [estateTable query:@{ @"id": estateData.estateId } error:nil];
        if (results != nil && results.count == 1)
        {
            //already exist, then update it
            DBRecord *firstResult = [results objectAtIndex:0];
            firstResult[@"Data"] = data;
        }
        else
        {
            //not found, then create it.
            [estateTable insert:@{ @"id":estateData.estateId, @"data": data, @"deleted": estateData.recycled ? @YES: @NO, @"lastUpdate" : estateData.lastUpdate }];
        }
    }
    [self.store sync:nil];
}

@end
