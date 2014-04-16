//
//  PasscodeViewController.m
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "PasscodeViewController.h"
#import "AppDelegate.h"

@interface PasscodeViewController ()

@end

@implementation PasscodeViewController

int passcode1 = -1;
int passcode2 = -1;
int passcode3 = -1;
int passcode4 = -1;

UIImage* onImage = nil;
UIImage* offImage = nil;

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
    passcode1 = -1;
    passcode2 = -1;
    passcode3 = -1;
    passcode4 = -1;
    
    if (onImage == nil)
        onImage = [UIImage imageNamed:@"on.png"];
    if (offImage == nil)
        offImage = [UIImage imageNamed:@"off.png"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBAction

- (IBAction)codeButtonTouched:(id)sender
{
    int code = [self getCodeButton:sender];
    if (code < 0)
        return;
    if (code == 10)
    {
        if (passcode4 != -1)
        {
            passcode4 = -1;
        }
        else
            if (passcode3 != -1)
            {
                passcode3 = -1;
            }
            else
                if (passcode2 != -1)
                {
                    passcode2 = -1;
                }
                else
                    if (passcode1 != -1)
                    {
                        passcode1 = -1;
                    }
    }
    else
    {
        if (passcode1 == -1)
        {
            passcode1 = code;
        }
        else
            if (passcode2 == -1)
            {
                passcode2 = code;
            }
            else
                if (passcode3 == -1)
                {
                    passcode3 = code;
                }
                else
                    if (passcode4 == -1)
                    {
                        passcode4 = code;
                    }
    }
    [self updateLightImage];
    
    if (passcode1 != -1 && passcode2 != -1 && passcode3 != -1 && passcode4 != -1)
    {
        @try {
            [self performSegueWithIdentifier:@"PasswordVerifySegue" sender:self];
        }
        @catch (NSException *exception) {
            NSLog(@"Segue not found: %@", exception);
            
            
            
            //if segue not exist, it means we are the verification view

            //todo: check the code matches, if yes, then jump to EstateTabView.
            //if now, then jump back to Password view.
            
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            UINavigationController* navigationController = (UINavigationController*)[[app window] rootViewController];
            [navigationController popViewControllerAnimated:TRUE];
            
            //    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
            //    [prefs setBool:TRUE forKey:@"hasLogon"];
            //    [prefs synchronize];

//            UIViewController *screen = [self.storyboard instantiateViewControllerWithIdentifier:@"EstateTabViewController"];
//            [app.window setRootViewController:screen];
        }
    }
}

- (int)getCodeButton:(id)sender
{
    if (sender == nil)
        return -1;
    if (sender == _button0)
        return 0;
    if (sender == _button1)
        return 1;
    if (sender == _button2)
        return 2;
    if (sender == _button3)
        return 3;
    if (sender == _button4)
        return 4;
    if (sender == _button5)
        return 5;
    if (sender == _button6)
        return 6;
    if (sender == _button7)
        return 7;
    if (sender == _button8)
        return 8;
    if (sender == _button9)
        return 9;
    if (sender == _button_del)
        return 10;
    return -1;
}

- (void)updateLightImage
{
    [_light1 setImage:(passcode1 == -1 ? offImage: onImage)];
    [_light2 setImage:(passcode2 == -1 ? offImage: onImage)];
    [_light3 setImage:(passcode3 == -1 ? offImage: onImage)];
    [_light4 setImage:(passcode4 == -1 ? offImage: onImage)];
}

@end