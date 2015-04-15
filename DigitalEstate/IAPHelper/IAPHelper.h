//
//  IAPHelper.h
//  DigitalEstate
//
//  Created by ChenYi on 15/04/2015.
//  Copyright (c) 2015 Yi Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface IAPHelper : NSObject

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

@end
