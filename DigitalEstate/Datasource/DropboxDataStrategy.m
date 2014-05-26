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
    DBTable *estateTable = [self.store getTable:kEstateTable];
    NSArray *recordArray = [estateTable query:@{} error:nil];

    if (recordArray == nil || recordArray.count == 0)
        return nil;
    
    DBRecord* record = [recordArray objectAtIndex:0];
    NSData* data = record[@"data"];
    NSArray* estateDatas = [DataEncryptUtil decryptData:data];
    return estateDatas;
}

- (void)saveEstateData:(NSArray*) estateDataArray
{
    DBTable *estateTable = [self.store getTable:kEstateTable];
    
    NSData* encryptedData = [DataEncryptUtil encryptData:estateDataArray];

    NSArray *results = [estateTable query:@{} error:nil];
    if (results != nil && results.count == 1)
    {
        //already exist, then update it
        DBRecord *firstResult = [results objectAtIndex:0];
        firstResult[@"data"] = encryptedData;
        firstResult[@"lastUpdate"] = [NSDate date];
    }
    else
    {
        //not found, then create it.
        [estateTable insert:@{@"data": encryptedData, @"lastUpdate": [NSDate date]}];
    }
    [self.store sync:nil];
}

@end
