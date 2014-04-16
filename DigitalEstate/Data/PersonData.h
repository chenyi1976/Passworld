//
//  PersonData.h
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNameKey @"Name"
#define kEmailKey @"Email"

@interface PersonData : NSObject<NSCoding>

@property NSString* name;
@property NSString* email;

- (id) initWithName:(NSString*)title email:(NSString*)email;


@end
