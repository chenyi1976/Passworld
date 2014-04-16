//
//  DownloadManager.h
//  auchinesemedia
//
//  Created by Yi Chen on 3/03/2014.
//  Copyright (c) 2014 ChenYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebsiteLinkEntry.h"

@interface DownloadManager : NSObject

@property (nonatomic, strong) WebsiteLinkEntry *appRecord;
@property (nonatomic, copy) void (^completionHandler)(void);

+ (DownloadManager*)sharedInstance;

- (void)startDownload;
- (void)cancelDownload;

@end
