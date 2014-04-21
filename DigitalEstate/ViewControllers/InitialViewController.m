//
//  InitialViewController.m
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "InitialViewController.h"
#import "AppDelegate.h"

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
    
    
    BOOL hasLogon = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasLogon"];

    if (hasLogon)
    {
        [self gotoScreen:@"EstateTabViewController"];
    }
    else
    {
        NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
        [prefs removeObjectForKey:@"temppass1"];
        [prefs removeObjectForKey:@"temppass2"];
        [prefs removeObjectForKey:@"temppass3"];
        [prefs removeObjectForKey:@"temppass4"];
        [prefs synchronize];

        [self gotoScreen:@"RegisterNavigationViewController"];
    }
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
