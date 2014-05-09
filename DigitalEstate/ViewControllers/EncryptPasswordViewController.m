//
//  EncryptPasswordViewController.m
//  DigitalEstate
//
//  Created by Yi Chen on 1/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "EncryptPasswordViewController.h"
#import "AppDelegate.h"
#import "ConstantDefinition.h"
#import "KeychainItemWrapper.h"

@interface EncryptPasswordViewController ()

@end

@implementation EncryptPasswordViewController

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
    [_passwordField1 setDelegate:self];
    [_passwordField2 setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _passwordField1)
    {
        [_passwordField2 becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}


#pragma mark - IBAction

- (IBAction)confirmButtonTouched:(id)sender
{
    NSString* pass1 = _passwordField1.text;
    NSString* pass2 = _passwordField2.text;
    if (pass1.length == 0 || ![pass1 isEqualToString:pass2])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"密码没有设置或者不匹配" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        alert.alertViewStyle=UIAlertViewStyleDefault;
        [alert show];
        return;
    }
    
//    KeychainItemWrapper* keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"TestUDID" accessGroup:nil];
//    [keychain setObject:udid forKey:(__bridge id)(kSecAttrAccount)];
    
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:pass1 forKey:kEncryptKey];
    [prefs synchronize];

    
    UIViewController *screen = [self.storyboard instantiateViewControllerWithIdentifier:@"EstateViewController"];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.window setRootViewController:screen];
}

@end
