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

+(void) dismissToViewController:(Class)viewControllerClass fromView:(UIViewController*) currentController Animated:(BOOL)animated completion:(void (^)(void))completion
{
    if (currentController == nil)
        return;
    
    while (currentController.presentingViewController != nil
           && ![currentController isKindOfClass:viewControllerClass])
    {
        currentController = currentController.presentingViewController;
    }
    
    [currentController dismissViewControllerAnimated:animated completion:completion];
}

+ (void)popupMessage:(NSString*) message forView:(UIView*) view{
    
//    UIWindow* window = [UIApplication sharedApplication].keyWindow;
//    if (!window) {
//        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//    }
//    
//    UIViewController* rootViewController = [window rootViewController];
    
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(80, 160, 160, 160)];
    [messageView setTag:103];
    [messageView setBackgroundColor:[UIColor blackColor]];
    [messageView setAlpha:0.8];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 160.0f, 160.0f)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor] ];
    [label setText:message];
    [messageView addSubview:label];
    
    [view addSubview:messageView];
    
    messageView.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
    
//    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.3f
                         animations:^{
                             messageView.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL cancelled){
//                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [UIView animateWithDuration:.3f
                                                       delay:0.7f
                                                     options:UIViewAnimationOptionCurveEaseIn
                                                  animations:^{
                                                      messageView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
                                                  }
                                                  completion:^(BOOL cancelled){
                                                      [messageView removeFromSuperview];
                                                  }];
//                             });
                         }
         ];
//    });
}


@end
