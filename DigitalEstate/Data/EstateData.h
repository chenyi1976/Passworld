//
//  EstateData.h
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kName @"name"
#define kContent @"content"
#define kAttributeValues @"attributeValues"
#define kLastUpdate @"lastUpdate"
#define kHistory @"history"

#define historyCount 10

@interface EstateData : NSObject<NSCoding, NSCopying>

@property(nonatomic) NSString* name;
@property(nonatomic) NSString* content;
@property(nonatomic) NSMutableArray* attributeValues;
@property(readonly) NSDate* lastUpdate;
@property(readonly) NSMutableArray* history;

- (id) initWithName:(NSString*)name withContent:(NSString*)content withAttributeValues:(NSMutableArray*)attributeValues withLastUpdate:(NSDate*)lastUpdate withHistory:(NSMutableArray*)history;

@end
