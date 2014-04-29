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
#import "DiallingCodesUtil.h"
#import "ConstantDefinition.h"

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
    if (_phoneField)
    {
        [_phoneField becomeFirstResponder];
    }
    else
    {
        [_codeField becomeFirstResponder];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString* countryCode = [[NSUserDefaults standardUserDefaults] objectForKey:kCountryCode];
//    NSLog(@"%@", countryCode);
    if (countryCode)
    {
        NSString* countryName = [[DiallingCodesUtil sharedInstance] getCountryNameForCode:countryCode];
        [_countryButton setTitle:countryName forState:UIControlStateNormal];
        NSString* dialingCode = [[DiallingCodesUtil sharedInstance] getDiallingCodeForCountryCode:countryCode];
        [_countryField setText:[NSString stringWithFormat:@"+%@", dialingCode]];
    }
    else
    {
        NSLocale *locale = [NSLocale autoupdatingCurrentLocale];
        NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
        NSString *countryName = [locale displayNameForKey: NSLocaleCountryCode value:countryCode];
        [_countryButton setTitle:countryName forState:UIControlStateNormal];

        NSString* dialingCode = [[DiallingCodesUtil sharedInstance] getDiallingCodeForCountryCode:countryCode];
        [_countryField setText:[NSString stringWithFormat:@"+%@", dialingCode]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)requestButtonClicked:(id)sender
{
    NSString* phoneNo = nil;
    if (_phoneField)
    {
        phoneNo = _phoneField.text;
    }
    if (phoneNo == nil || phoneNo.length == 0)
    {
        phoneNo = [[NSUserDefaults standardUserDefaults] objectForKey:kPhoneNo];
    }
    
    if (phoneNo == nil || phoneNo.length == 0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        alert.alertViewStyle=UIAlertViewStyleDefault;
        [alert show];
        return;
    }

    [SMSService requestCodeVerficationForPhone:_phoneField.text];
    
    NSUserDefaults* perf = [NSUserDefaults standardUserDefaults];
    [perf setObject:phoneNo forKey:kPhoneNo];
    [perf synchronize];
    
    @try {
        [self performSegueWithIdentifier:@"smsVerifySegue" sender:nil];
    }
    @catch (NSException *exception) {
        //ignore the segue exception
    }
}

- (IBAction)verifyButtonClicked:(id)sender
{
    NSString* code = _codeField.text;
    if (code.length != 6)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入6位验证数字" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        alert.alertViewStyle=UIAlertViewStyleDefault;
        [alert show];
        return;
    }
    
    NSString* phoneNo = [[NSUserDefaults standardUserDefaults] objectForKey:kPhoneNo];
    
    bool verifyResult = [SMSService verifyCode:_codeField.text ForPhone:phoneNo];
    if (verifyResult)
    {
        [self performSegueWithIdentifier:@"pinSetupSegue" sender:nil];
    }
}


@end
