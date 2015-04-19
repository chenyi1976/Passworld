//
//  EstateData.m
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "EstateData.h"
#import "HistoryData.h"
#import "AttributeData.h"
#import "ConstantDefinition.h"

@implementation EstateData

- (id) initWithId:(NSString*)estateId withName:(NSString*)name withContent:(NSString*)content withAttributeValues:(NSMutableArray*)attributeValues withLastUpdate:(NSDate*)lastUpdate withLastVisit:(NSDate*)lastVisit withHistory:(NSMutableArray*)history withDeleted:(BOOL)deleted
{
    if (self = [super init])
    {
        _estateId = estateId;
        _name = name;
        _content = content;
        _lastUpdate = lastUpdate;
        _lastVisit = lastVisit;
        _deleted = deleted;
        _synced = false;
        if (history)
            _history = history;
        else
            _history = [[NSMutableArray alloc] init];
        if (attributeValues)
            _attributeValues = attributeValues;
        else
            _attributeValues = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark NSCoding

- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_estateId forKey:kId];
    [encoder encodeObject:_name forKey:kName];
    [encoder encodeObject:_content forKey:kContent];
    [encoder encodeObject:_attributeValues forKey:kAttributeValues];
    [encoder encodeObject:_lastUpdate forKey:kLastUpdate];
    [encoder encodeObject:_lastVisit forKey:kLastVisit];
    [encoder encodeObject:_history forKey:kHistory];
    [encoder encodeBool:_deleted forKey:kDeleted];
}


- (id) initWithCoder:(NSCoder*)decoder
{
    NSString* estateId = [decoder decodeObjectForKey:kId];
    NSString* name = [decoder decodeObjectForKey:kName];
    NSString* content = [decoder decodeObjectForKey:kContent];
    NSMutableArray* attributeValues = [decoder decodeObjectForKey:kAttributeValues];
    NSDate* lastUpdate = [decoder decodeObjectForKey:kLastUpdate];
    NSDate* lastVisit = [decoder decodeObjectForKey:kLastVisit];
    NSMutableArray* history = [decoder decodeObjectForKey:kHistory];
    bool deleted = [decoder decodeBoolForKey:kDeleted];
    
    return [self initWithId:estateId withName:name withContent:content withAttributeValues:attributeValues withLastUpdate:lastUpdate withLastVisit:lastVisit withHistory:history withDeleted:deleted];
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return [[EstateData alloc] initWithId:self.estateId withName:self.name withContent:self.content withAttributeValues:self.attributeValues withLastUpdate:self.lastUpdate withLastVisit:self.lastVisit withHistory:self.history withDeleted:self.deleted];
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
    
    AttributeData* data = [[AttributeData alloc] initWithId:kAttrContent name:@"content" value:_content];
    [_history addObject:[[HistoryData alloc] initWithAttributeData:data withDate:[NSDate date]]];
    _content = content;
    _lastUpdate = [NSDate date];
}

- (void)addAttributeData:(AttributeData*)data
{
    if (data == nil)
        return;
    
    _lastUpdate = [NSDate date];

    if (_history.count >= historyCount)
        [_history removeObjectAtIndex:0];
    [_history addObject:[[HistoryData alloc] initWithAttributeData:data withDate:_lastUpdate]];
    [_attributeValues addObject:data];
    
}

@end
