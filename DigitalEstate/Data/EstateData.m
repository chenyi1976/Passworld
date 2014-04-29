//
//  EstateData.m
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "EstateData.h"

@implementation EstateData

- (id) initWithName:(NSString*)name withContent:(NSString*)content withLastUpdate:(NSDate*)lastUpdate
{
    if (self = [super init])
    {
        _name = name;
        _content = content;
        _lastUpdate = lastUpdate;
    }
    return self;
}

#pragma mark NSCoding

- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_name forKey:kNameKey];
    [encoder encodeObject:_content forKey:kContentKey];
    [encoder encodeObject:_lastUpdate forKey:kLastUpdate];
}


- (id) initWithCoder:(NSCoder*)decoder
{
    NSString* name = [decoder decodeObjectForKey:kNameKey];
    NSString* content = [decoder decodeObjectForKey:kContentKey];
    NSDate* lastUpdate = [decoder decodeObjectForKey:kLastUpdate];
    
    return [self initWithName:name withContent:content withLastUpdate:lastUpdate];
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return [[EstateData alloc] initWithName:self.name withContent:self.content withLastUpdate:self.lastUpdate];
}



@end
