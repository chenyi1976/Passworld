//
//  EstateData.h
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kId @"id"
#define kName @"name"
#define kContent @"content"
#define kAttributeValues @"attributeValues"
#define kLastUpdate @"lastUpdate"
#define kHistory @"history"
#define kDeleted @"deleted"

#define historyCount 10

@interface EstateData : NSObject<NSCoding, NSCopying>

@property(nonatomic) NSString* estateId;
@property(nonatomic) NSString* name;
@property(nonatomic) NSString* content;
@property(nonatomic) NSMutableArray* attributeValues;
@property(readonly) NSDate* lastUpdate;
@property(readonly) NSMutableArray* history;
//whether in recycle bin or not
@property BOOL deleted;
//whether sync with cloud service or not, if stored locally, it should be false
//this is a run time property, will not be saved.
@property BOOL synced;

- (id) initWithId:(NSString*)estateId withName:(NSString*)name withContent:(NSString*)content withAttributeValues:(NSMutableArray*)attributeValues withLastUpdate:(NSDate*)lastUpdate withHistory:(NSMutableArray*)history withDeleted:(BOOL)deleted;

@end
