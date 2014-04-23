//
//  RegistrationViewController.m
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "RegistrationViewController.h"
#import "AppDelegate.h"
#import "SMSService.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

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
    [_phoneField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)requestButtonClicked:(id)sender
{
    NSString* phoneNo = _phoneField.text;
    if (!phoneNo)
        return;
    if (phoneNo.length == 0)
        return;
    
    [SMSService requestCodeVerficationForPhone:_phoneField.text];
    
    NSUserDefaults* perf = [NSUserDefaults standardUserDefaults];
    [perf setObject:phoneNo forKey:@"phoneNo"];
    [perf synchronize];
}

- (IBAction)verifyButtonClicked:(id)sender
{
    NSString* code = _codeField.text;
    if (!code)
        return;
    if (code.length != 6)
        return;
    
    NSString* phoneNo = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNo"];
    
    bool verifyResult = [SMSService verifyCode:_codeField.text ForPhone:phoneNo];
    if (verifyResult)
    {
        
    }
}


@end
