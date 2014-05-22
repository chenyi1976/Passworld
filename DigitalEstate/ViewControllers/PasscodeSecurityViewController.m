//
//  PasscodeSecurityViewController.m
//  DigitalEstate
//
//  Created by Yi Chen on 21/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "PasscodeSecurityViewController.h"
#import "ConstantDefinition.h"
#import "ViewUtil.h"

@interface PasscodeSecurityViewController ()

@end

@implementation PasscodeSecurityViewController

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
            //the passcode is matched, then goes to estate view
            [self performSegueWithIdentifier:@"SecurityVerifiedSegue" sender:self];
        }
        else
        {
            [super reset];
        }
}

#pragma mark IBAction

- (IBAction)cancelButtonTouched:(id)sender
{
    [ViewUtil dismissToRootViewController:self Animated:TRUE completion:nil];
}

@end
