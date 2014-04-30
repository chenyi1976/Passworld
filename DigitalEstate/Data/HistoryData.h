//
//  HistoryData.h
//  DigitalEstate
//
//  Created by Yi Chen on 30/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAttribute @"attribute"
#define kValue @"value"
#define kDate @"date"

@interface HistoryData : NSObject<NSCoding, NSCopying>

@property(readonly) NSString* attribute;
@property(readonly) id value;
@property(readonly) NSDate* date;

- (id) initWithAttribute:(NSString*)attribute withValue:(NSString*)value withDate:(NSDate*)date;

@end
