//
//  ViewUtil.h
//  DigitalEstate
//
//  Created by Yi Chen on 22/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewUtil : NSObject

+(void) dismissToRootViewController:(UIViewController*) currentController Animated:(BOOL)animated completion:(void (^)(void))completion;

@end
