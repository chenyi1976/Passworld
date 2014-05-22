//
//  AttributeData.h
//  DigitalEstate
//
//  Created by Yi Chen on 15/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAttrId @"attrId"
#define kAttrName @"attrName"
#define kAttrValue @"attrValue"

@interface AttributeData : NSObject<NSCoding, NSCopying>

@property(nonatomic) NSString* attrId;
@property(nonatomic) NSString* attrName;
@property(nonatomic) NSString* attrValue;

- (id) initWithId:(NSString*)attrId name:(NSString*)name value:(NSString*)value;

@end
