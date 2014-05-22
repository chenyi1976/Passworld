//
//  ViewUtil.m
//  DigitalEstate
//
//  Created by Yi Chen on 22/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "ViewUtil.h"

@implementation ViewUtil

+(void) dismissToRootViewController:(UIViewController*) currentController Animated:(BOOL)animated completion:(void (^)(void))completion
{
    if (currentController == nil)
        return;
    
    while (currentController.presentingViewController != nil)
    {
        currentController = currentController.presentingViewController;
    }
    
    [currentController dismissViewControllerAnimated:animated completion:completion];
}

@end
