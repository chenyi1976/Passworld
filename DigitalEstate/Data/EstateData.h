//
//  EstateData.h
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNameKey @"Name"
#define kContentKey @"Content"
#define kLastUpdate @"lastUpdate"

@interface EstateData : NSObject<NSCoding, NSCopying>

@property NSString* name;
@property NSString* content;
@property NSDate* lastUpdate;

- (id) initWithName:(NSString*)name withContent:(NSString*)content withLastUpdate:(NSDate*)lastUpdate;

@end
