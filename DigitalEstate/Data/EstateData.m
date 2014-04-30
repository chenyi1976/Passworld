//
//  EstateData.m
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "EstateData.h"
#import "HistoryData.h"

@implementation EstateData

- (id) initWithName:(NSString*)name withContent:(NSString*)content withAttributeValues:(NSMutableDictionary*)attributeValues withLastUpdate:(NSDate*)lastUpdate withHistory:(NSMutableArray*)history
{
    if (self = [super init])
    {
        _name = name;
        _content = content;
        _lastUpdate = lastUpdate;
        if (history)
            _history = history;
        else
            _history = [[NSMutableArray alloc] init];
        if (attributeValues)
            _attributeValues = attributeValues;
        else
            _attributeValues = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark NSCoding

- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_name forKey:kName];
    [encoder encodeObject:_content forKey:kContent];
    [encoder encodeObject:_attributeValues forKey:kAttributeValues];
    [encoder encodeObject:_lastUpdate forKey:kLastUpdate];
    [encoder encodeObject:_history forKey:kHistory];
}


- (id) initWithCoder:(NSCoder*)decoder
{
    NSString* name = [decoder decodeObjectForKey:kName];
    NSString* content = [decoder decodeObjectForKey:kContent];
    NSMutableDictionary* attributeValues = [decoder decodeObjectForKey:kAttributeValues];
    NSDate* lastUpdate = [decoder decodeObjectForKey:kLastUpdate];
    NSMutableArray* history = [decoder decodeObjectForKey:kHistory];
    
    return [self initWithName:name withContent:content withAttributeValues:attributeValues withLastUpdate:lastUpdate withHistory:history];
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return [[EstateData alloc] initWithName:self.name withContent:self.content withAttributeValues:self.attributeValues withLastUpdate:self.lastUpdate withHistory:self.history];
}

#pragma mark Synthesize

- (void)setName:(NSString *)name
{
    if (name == nil)
        return;
    
    if ([name isEqualToString:_name])
        return;

    _name = name;
    _lastUpdate = [NSDate date];
}

- (void)setContent:(NSString *)content
{
    if (content == nil)
        return;
    
    if ([content isEqualToString:_content])
        return;
    
    _lastUpdate = [NSDate date];

    if (_history.count >= historyCount)
        [_history removeObjectAtIndex:0];
    [_history addObject:[[HistoryData alloc] initWithAttribute:kContent withValue:content withDate:[NSDate date]]];
    _content = content;
    _lastUpdate = [NSDate date];
}

- (void)setAttributeValue:(id)value forKey:(NSString *)attribute
{
    if (attribute == nil)
        return;
    
    _lastUpdate = [NSDate date];

    if (_history.count >= historyCount)
        [_history removeObjectAtIndex:0];
    [_history addObject:[[HistoryData alloc] initWithAttribute:attribute withValue:value withDate:_lastUpdate]];
    if (value == nil)
        [_attributeValues removeObjectForKey:attribute];
    else
        [_attributeValues setObject:value forKey:attribute];
    
}

@end
