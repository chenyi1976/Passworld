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

@interface EstateData : NSObject<NSCoding>

@property NSString* name;
@property NSString* content;

- (id) initWithName:(NSString*)name Content:(NSString*)content;

@end
