//
//  HistoryData.m
//  DigitalEstate
//
//  Created by Yi Chen on 30/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "HistoryData.h"

@implementation HistoryData

- (id) initWithAttributeData:(AttributeData*)data withDate:(NSDate*)date
{
    if (self = [super init])
    {
        _data = data;
        _date = date;
    }
    return self;
}

#pragma mark NSCoding

- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_data forKey:kAttribute];
    [encoder encodeObject:_date forKey:kDate];
}


- (id) initWithCoder:(NSCoder*)decoder
{
    AttributeData* data = [decoder decodeObjectForKey:kAttribute];
    NSDate* date = [decoder decodeObjectForKey:kDate];
    
    return [self initWithAttributeData:data withDate:date];
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return [[HistoryData alloc] initWithAttributeData:_data withDate:_date];
}

@end
