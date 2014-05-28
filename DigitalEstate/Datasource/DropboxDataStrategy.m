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

- (id)initWithDataSource:(EstateDataSource*)datasource
{
    if (self = [super init])
    {
        
        DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
        _store = [DBDatastore openDefaultStoreForAccount:account error:nil];
        _datasource = datasource;
        
        __weak typeof(self) weakSelf = self;
        [_store addObserver:self block:^{
            NSLog(@"store status: %lu", (unsigned long)weakSelf.store.status);
            if (weakSelf.store.status & (DBDatastoreIncoming | DBDatastoreOutgoing)) {
                [weakSelf.store sync:nil];
            }
            if (weakSelf.store.status == DBDatastoreConnected)
            {
                NSArray* loadedData = [weakSelf loadDropboxDatastore];
                [weakSelf.datasource estateDataLoaded:loadedData];
            }
        }];
    }
    return self;
}

- (NSArray*)loadDropboxDatastore
{
    DBTable *estateTable = [_store getTable:kEstateTable];
    
    NSArray *recordArray = [estateTable query:nil error:nil];
    
    DBRecord* record = [recordArray objectAtIndex:0];
    NSData* data = record[kFieldData];
    NSArray* estateDatas = [DataEncryptUtil decryptData:data];
    return estateDatas;
}

- (NSArray*)loadEstateData
{
    [_store sync:nil];
    return [self loadDropboxDatastore];
}

- (void)saveEstateData:(NSArray*) estateDataArray
{
    DBTable *estateTable = [self.store getTable:kEstateTable];
    
    NSData* encryptedData = [DataEncryptUtil encryptData:estateDataArray];
    
    if (encryptedData == nil)
    {
        NSLog(@"DropboxDataStrategy saveEstatateData: data is nil");
        return;
    }

    NSArray *results = [estateTable query:nil error:nil];
    if (results != nil && results.count != 0)
    {
        //already exist, then update it
        DBRecord *firstResult = [results objectAtIndex:0];
        firstResult[kFieldData] = encryptedData;
        firstResult[kFieldLastUpdate] = [NSDate date];
    }
    else
    {
        //not found, then create it.
        [estateTable insert:@{kFieldData: encryptedData, kFieldLastUpdate: [NSDate date]}];
    }
}

@end
