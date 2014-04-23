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

    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];

    int pass1 = [prefs integerForKey:@"passcode1"];
    int pass2 = [prefs integerForKey:@"passcode2"];
    int pass3 = [prefs integerForKey:@"passcode3"];
    int pass4 = [prefs integerForKey:@"passcode4"];
    
    if (pass1 == 0 && pass2 == 0 && pass3 == 0 && pass4 == 0)
    {
        [self gotoScreen:@"RegisterNavigationViewController"];
    }
    else
    {
        [self gotoScreen:@"EstateViewController"];
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
