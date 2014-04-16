//
//  ArticleEntry.m
//  auchinesemedia
//
//  Created by Yi Chen on 12/02/2014.
//  Copyright (c) 2014 ChenYi. All rights reserved.
//

#import "WebsiteLinkEntry.h"

@implementation WebsiteLinkEntry

- (id) initWithTitle:(NSString*)title url:(NSString*)url image:(NSString*)image
{
    if (self = [super init])
    {
        _title = title;
        _url = url;
        _image = image;
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_title forKey:kTitleKey];
    [encoder encodeObject:_url forKey:kUrlKey];
    [encoder encodeObject:_image forKey:kImageKey];
    
}


- (id) initWithCoder:(NSCoder*)decoder
{
    NSString* title = [decoder decodeObjectForKey:kTitleKey];
    NSString* url = [decoder decodeObjectForKey:kUrlKey];
    NSString* image = [decoder decodeObjectForKey:kImageKey];
    
    return [self initWithTitle:title url:url image:image];
}

@end
