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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_countryButton && _countryField)
    {
        NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
        NSString* diallingCode = [prefs objectForKey:kDiallingCode];
        NSString* countryCode = [prefs objectForKey:kCountryCode];
        if (countryCode && diallingCode)
        {
            NSString* countryName = [[DiallingCodesUtil sharedInstance] getCountryNameForCode:countryCode];
            [_countryButton setTitle:countryName forState:UIControlStateNormal];
            
            [_countryField setText:[NSString stringWithFormat:@"+%@", diallingCode]];
        }
        else
        {
            NSLocale *locale = [NSLocale autoupdatingCurrentLocale];
            NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
            NSString *countryName = [locale displayNameForKey: NSLocaleCountryCode value:countryCode];
            [_countryButton setTitle:countryName forState:UIControlStateNormal];
            
            diallingCode = [[DiallingCodesUtil sharedInstance] getDiallingCodeForCountryCode:countryCode];
            
            [prefs setObject:diallingCode forKey:kDiallingCode];
            [prefs setObject:countryCode forKey:kCountryCode];
            [prefs synchronize];
            
            [_countryField setText:[NSString stringWithFormat:@"+%@", diallingCode]];
        }
    }
    
    if (_phoneField)
    {
        [_phoneField becomeFirstResponder];
    }
    else if (_codeField)
    {
        [_codeField becomeFirstResponder];
    }
    
    if (_phoneNoLabel)
    {
        NSString* phoneNo = [[NSUserDefaults standardUserDefaults] objectForKey:kPhoneNo];
        NSString* diallingCode = [[NSUserDefaults standardUserDefaults] objectForKey:kDiallingCode];

        [_phoneNoLabel setText:[NSString stringWithFormat:@"Your phone number is : +%@ %@", diallingCode, phoneNo]];
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
    if (_phoneField)
    {
        if (_phoneField.text.length == 0)
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            alert.alertViewStyle=UIAlertViewStyleDefault;
            [alert show];
            return;
        }
    }
    
    NSString* phoneNo = _phoneField.text;
    if ([phoneNo hasPrefix:@"0"])
        phoneNo = [phoneNo substringFromIndex:1];
    
    NSUserDefaults* perf = [NSUserDefaults standardUserDefaults];
    [perf setObject:phoneNo forKey:kPhoneNo];
    [perf synchronize];
    
    NSString* fullPhoneNo = [NSString stringWithFormat:@"%@%@", _countryField.text, phoneNo];
    if ([fullPhoneNo hasPrefix:@"+"])
        fullPhoneNo = [fullPhoneNo substringFromIndex:1];
    
    [SMSService requestCodeVerficationForPhone:fullPhoneNo];
    
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
    if (code.length == 0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入6位验证数字" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        alert.alertViewStyle=UIAlertViewStyleDefault;
        [alert show];
        return;
    }
    
    NSString* phoneNo = [[NSUserDefaults standardUserDefaults] objectForKey:kPhoneNo];
    NSString* diallingCode = [[NSUserDefaults standardUserDefaults] objectForKey:kDiallingCode];
    NSString* fullPhoneNo = [NSString stringWithFormat:@"%@%@", diallingCode, phoneNo];
    
    [SMSService verifyCode:_codeField.text ForPhone:fullPhoneNo completionHandler:^(NSError* error){
        if (error == nil)
            [self performSegueWithIdentifier:@"pinSetupSegue" sender:nil];
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"验证失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            alert.alertViewStyle=UIAlertViewStyleDefault;
            [alert show];
            return;
        }
    }];
}


@end
