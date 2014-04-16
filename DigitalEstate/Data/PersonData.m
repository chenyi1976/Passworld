//
//  PersonData.m
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "PersonData.h"

@implementation PersonData

- (id) initWithName:(NSString*)name email:(NSString*)email
{
    if (self = [super init])
    {
        _name = name;
        _email = email;
    }
    return self;
}


- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_name forKey:kNameKey];
    [encoder encodeObject:_email forKey:kEmailKey];
}


- (id) initWithCoder:(NSCoder*)decoder
{
    NSString* name = [decoder decodeObjectForKey:kNameKey];
    NSString* email = [decoder decodeObjectForKey:kEmailKey];
    
    return [self initWithName:name email:email];
}


@end
