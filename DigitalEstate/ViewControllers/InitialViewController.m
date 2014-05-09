//
//  InitialViewController.m
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "InitialViewController.h"
#import "AppDelegate.h"
#import "ConstantDefinition.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];

    long pass1 = [prefs integerForKey:kPassword1];
    long pass2 = [prefs integerForKey:kPassword2];
    long pass3 = [prefs integerForKey:kPassword3];
    long pass4 = [prefs integerForKey:kPassword4];
    
    NSString* encryptKey = [prefs objectForKey:kEncryptKey];
    
    if (encryptKey != nil)
    {
        if (pass1 != 0 || pass2 != 0 || pass3 != 0 || pass4 != 0)
        {
            [self gotoScreen:@"SecurityPassViewController"];
            return;
        }
    }

    //clear all setting before configuration
//    [prefs removeObjectForKey:kPhoneNo];
//    [prefs removeObjectForKey:kDiallingCode];
//    [prefs removeObjectForKey:kCountryCode];
//    [prefs synchronize];
    
    [self gotoScreen:@"RegisterNavigationViewController"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Jump to right view

- (void)gotoScreen:(NSString *)theScreen
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIViewController *screen = [self.storyboard instantiateViewControllerWithIdentifier:theScreen];
    [app.window setRootViewController:screen];
}

@end
