//
//  AuChineseMediaDataSource.h
//  auchinesemedia
//
//  Created by Yi Chen on 13/02/2014.
//  Copyright (c) 2014 ChenYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EstateDataSource.h"

#define kRencentKey @"recent"
#define kCategoryListKey @"categoryList"
#define kCategoryArticleKey @"categoryArticle"
#define kHistoryArticleKey @"historyArticle"

@interface MockDataSource : NSObject<EstateDataSource>

@end