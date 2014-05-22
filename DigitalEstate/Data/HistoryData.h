//
//  HistoryData.h
//  DigitalEstate
//
//  Created by Yi Chen on 30/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttributeData.h"

#define kAttribute @"attribute"
#define kDate @"date"

@interface HistoryData : NSObject<NSCoding, NSCopying>

@property(readonly) AttributeData* data;
@property(readonly) NSDate* date;

- (id) initWithAttributeData:(AttributeData*)data withDate:(NSDate*)date;

@end
