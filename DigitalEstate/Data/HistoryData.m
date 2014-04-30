//
//  HistoryData.m
//  DigitalEstate
//
//  Created by Yi Chen on 30/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "HistoryData.h"
#import "ConstantDefinition.h"

@implementation HistoryData

- (id) initWithAttribute:(NSString*)attribute withValue:(NSString*)value withDate:(NSDate*)date
{
    if (self = [super init])
    {
        _attribute = attribute;
        _value = value;
        _date = date;
    }
    return self;
}

#pragma mark NSCoding

- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_attribute forKey:kAttribute];
    [encoder encodeObject:_value forKey:kValue];
    [encoder encodeObject:_date forKey:kDate];
}


- (id) initWithCoder:(NSCoder*)decoder
{
    NSString* attribute = [decoder decodeObjectForKey:kAttribute];
    id value = [decoder decodeObjectForKey:kValue];
    NSDate* date = [decoder decodeObjectForKey:kDate];
    
    return [self initWithAttribute:attribute withValue:value withDate:date];
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return [[HistoryData alloc] initWithAttribute:self.attribute withValue:self.value withDate:self.date];
}

@end
