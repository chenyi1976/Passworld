//
//  PasscodeViewController.m
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "PasscodeViewController.h"
#import "AppDelegate.h"
#import "ConstantDefinition.h"

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
        NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
        int oldPass1 = [prefs integerForKey:kTemppass1];
        int oldPass2 = [prefs integerForKey:kTemppass2];
        int oldPass3 = [prefs integerForKey:kTemppass3];
        int oldPass4 = [prefs integerForKey:kTemppass4];
        
        int pass1 = [prefs integerForKey:kPassword1];
        int pass2 = [prefs integerForKey:kPassword2];
        int pass3 = [prefs integerForKey:kPassword3];
        int pass4 = [prefs integerForKey:kPassword4];

        //if the passcode does not exist, it means configuration mode.
        if (pass1 == 0 && pass2 == 0 && pass3 == 0 && pass4 ==0)
        {
            //if temporary passcode does not exist, it is in the first view.
            if (oldPass1 == 0 && oldPass2 == 0 && oldPass3 == 0 && oldPass4 ==0)
            {
                [self performSegueWithIdentifier:@"PasswordVerifySegue" sender:self];
                
                NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
                [prefs setInteger:passcode1 forKey:kTemppass1];
                [prefs setInteger:passcode2 forKey:kTemppass2];
                [prefs setInteger:passcode3 forKey:kTemppass3];
                [prefs setInteger:passcode4 forKey:kTemppass4];
                [prefs synchronize];
            }
            else
            {
                //clear temporary passcode
                [prefs removeObjectForKey:kTemppass1];
                [prefs removeObjectForKey:kTemppass2];
                [prefs removeObjectForKey:kTemppass3];
                [prefs removeObjectForKey:kTemppass4];
                [prefs synchronize];
                
                if (oldPass1 == passcode1 && oldPass2 == passcode2 && oldPass3 == passcode3 && oldPass4 == passcode4)
                {
                    //save passcode.
                    [prefs setInteger:passcode1 forKey:kPassword1];
                    [prefs setInteger:passcode2 forKey:kPassword2];
                    [prefs setInteger:passcode3 forKey:kPassword3];
                    [prefs setInteger:passcode4 forKey:kPassword4];
                    [prefs synchronize];
                    
                    UIViewController *screen = [self.storyboard instantiateViewControllerWithIdentifier:@"EstateViewController"];
                    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    [app.window setRootViewController:screen];
                }
                else
                {
                    //todo: show the red image animation, then pop view.
                    [self.navigationController popViewControllerAnimated:TRUE];
                }

            }
        }
        else //running mode for security passcode check
        {
            if (pass1 == passcode1 && pass2 == passcode2 && pass3 == passcode3 && pass4 == passcode4)
            {
                //the passcode is matched, then goes to
                AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                UIViewController *screen = [self.storyboard instantiateViewControllerWithIdentifier:@"EstateViewController"];
                [app.window setRootViewController:screen];
            }
            else
            {
                //todo: show red image, then ask user to retry.
                
                passcode1 = -1;
                passcode2 = -1;
                passcode3 = -1;
                passcode4 = -1;
            }
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
