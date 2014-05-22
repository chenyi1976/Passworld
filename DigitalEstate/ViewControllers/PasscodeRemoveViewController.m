//
//  PasscodeSecurityViewController.m
//  DigitalEstate
//
//  Created by Yi Chen on 21/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "PasscodeRemoveViewController.h"
#import "ConstantDefinition.h"

@interface PasscodeRemoveViewController ()

@end

@implementation PasscodeRemoveViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark PasscodeViewController

- (void)passcodeDidEndEditing
{
        NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
        long pass1 = [prefs integerForKey:kPassword1];
        long pass2 = [prefs integerForKey:kPassword2];
        long pass3 = [prefs integerForKey:kPassword3];
        long pass4 = [prefs integerForKey:kPassword4];
        
        if (pass1 == passcode1 && pass2 == passcode2 && pass3 == passcode3 && pass4 == passcode4)
        {
            [prefs removeObjectForKey:kPassword1];
            [prefs removeObjectForKey:kPassword2];
            [prefs removeObjectForKey:kPassword3];
            [prefs removeObjectForKey:kPassword4];
            [prefs synchronize];
            
            [self dismissViewControllerAnimated:TRUE completion:nil];
        }
        else
        {
            [super reset];
        }
}

#pragma mark IBAction

- (IBAction)cancelButtonTouched:(id)sender
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}


@end
