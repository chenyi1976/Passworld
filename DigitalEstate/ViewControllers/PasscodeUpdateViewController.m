//
//  PasscodeViewController.m
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "PasscodeUpdateViewController.h"
#import "AppDelegate.h"
#import "ConstantDefinition.h"
#import "ViewUtil.h"

@interface PasscodeUpdateViewController ()
@end

@implementation PasscodeUpdateViewController


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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PasscodeViewController

- (void)passcodeDidEndEditing
{
        NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
        long oldPass1 = [prefs integerForKey:kTemppass1];
        long oldPass2 = [prefs integerForKey:kTemppass2];
        long oldPass3 = [prefs integerForKey:kTemppass3];
        long oldPass4 = [prefs integerForKey:kTemppass4];
        
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
                //we are "password confirm view"
                
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
                    
                    [ViewUtil dismissToRootViewController:self Animated:TRUE completion:nil];
                }
                else
                {
                    [self dismissViewControllerAnimated:TRUE completion:nil];
                }

            }
}

#pragma mark IBAction

- (IBAction)cancelButtonTouched:(id)sender
{
    [ViewUtil dismissToRootViewController:self Animated:TRUE completion:nil];
}


@end
