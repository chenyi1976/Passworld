//
//  ArticleEntry.h
//  auchinesemedia
//
//  Created by Yi Chen on 12/02/2014.
//  Copyright (c) 2014 ChenYi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTitleKey @"Title"
#define kUrlKey @"Url"
#define kImageKey @"Image"

@interface WebsiteLinkEntry : NSObject<NSCoding>

@property NSString* title;
@property NSString* url;
@property NSString* image;

- (id) initWithTitle:(NSString*)title url:(NSString*)url image:(NSString*)image;

@end
