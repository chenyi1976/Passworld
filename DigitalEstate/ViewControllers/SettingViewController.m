//
//  SettingViewController.m
//  DigitalEstate
//
//  Created by Yi Chen on 29/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "SettingViewController.h"
#import "ConstantDefinition.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    long pass1 = [prefs integerForKey:kPassword1];
    long pass2 = [prefs integerForKey:kPassword2];
    long pass3 = [prefs integerForKey:kPassword3];
    long pass4 = [prefs integerForKey:kPassword4];

    if (pass1 == 0 && pass2 == 0 && pass3 == 0 && pass4 ==0)
    {
        _switchPasswordButton.titleLabel.text = @"Turn Security PIN On";
        _updatePasswordButton.enabled = FALSE;
    }
    else
    {
        _switchPasswordButton.titleLabel.text = @"Turn Security PIN Off";
        _updatePasswordButton.enabled = TRUE;
    }
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

#pragma mark IBAction

- (IBAction)switchPasscodeButtonTouched:(id)sender
{
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    long pass1 = [prefs integerForKey:kPassword1];
    long pass2 = [prefs integerForKey:kPassword2];
    long pass3 = [prefs integerForKey:kPassword3];
    long pass4 = [prefs integerForKey:kPassword4];
    
    if (pass1 == 0 && pass2 == 0 && pass3 == 0 && pass4 ==0)
    {
        [self performSegueWithIdentifier:@"TurnOnPasscodeSegue" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"TurnOffPasscodeSegue" sender:self];
    }

}

@end