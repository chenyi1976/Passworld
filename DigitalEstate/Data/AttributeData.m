//
//  AttributeData.m
//  DigitalEstate
//
//  Created by Yi Chen on 15/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "AttributeData.h"

@implementation AttributeData

- (id) initWithId:(NSString*)attrId name:(NSString*)name value:(NSString*)value
{
    if (self = [super init])
    {
        _attrId = attrId;
        _attrName = name;
        _attrValue = value;
    }
    return self;
}

#pragma mark NSCoding

- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_attrId forKey:kAttrId];
    [encoder encodeObject:_attrName forKey:kAttrName];
    [encoder encodeObject:_attrValue forKey:kAttrValue];
}


- (id) initWithCoder:(NSCoder*)decoder
{
    NSString* attrId = [decoder decodeObjectForKey:kAttrId];
    NSString* name = [decoder decodeObjectForKey:kAttrName];
    NSString* value = [decoder decodeObjectForKey:kAttrValue];
    
    return [self initWithId:attrId name:name value:value];
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return [[AttributeData alloc] initWithId:_attrId name:_attrName value:_attrValue];
}


@end
