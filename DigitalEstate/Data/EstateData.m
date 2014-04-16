//
//  EstateData.m
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "EstateData.h"

@implementation EstateData

- (id) initWithName:(NSString*)name Content:(NSString*)content
{
    if (self = [super init])
    {
        _name = name;
        _content = content;
    }
    return self;
}


- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_name forKey:kNameKey];
    [encoder encodeObject:_content forKey:kContentKey];
}


- (id) initWithCoder:(NSCoder*)decoder
{
    NSString* name = [decoder decodeObjectForKey:kNameKey];
    NSString* content = [decoder decodeObjectForKey:kContentKey];
    
    return [self initWithName:name Content:content];
}


@end
