//
//  ViewController.m
//  PasscodeRecovery
//
//  Created by ChenYi on 16/02/2015.
//  Copyright (c) 2015 Yi Chen. All rights reserved.
//

#import "ViewController.h"
#import "KeyChainUtil.h"
#import "ConstantDefinition.h"
#import <UIKit/UIKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)displayPasscode {
    NSString* encryptKey = [KeyChainUtil loadFromKeyChainForKey:kEncryptKey];
    [_passcodeLabel setText:encryptKey];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayPasscode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popupMessage:(NSString*) message {
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    
    UIViewController* rootViewController = [window rootViewController];
    
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(80, 160, 160, 160)];
    [messageView setTag:103];
    [messageView setBackgroundColor:[UIColor blackColor]];
    [messageView setAlpha:0.8];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 160.0f, 160.0f)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor] ];
    [label setText:message];
    [messageView addSubview:label];
    
    [rootViewController.view addSubview:messageView];
    
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
                                                      messageView.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
                                                  }
                                                  completion:^(BOOL cancelled){
                                                      [messageView removeFromSuperview];
                                                  }];
//                             });
                         }
         ];
//    });
}

- (IBAction)buttonTouched:(id)sender {
    [self popupMessage:@"Hello World"];
}

@end
