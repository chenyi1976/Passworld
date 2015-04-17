//
//  SettingViewController.m
//  DigitalEstate
//
//  Created by Yi Chen on 29/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "SettingViewController.h"
#import "ConstantDefinition.h"
#import "Dropbox/Dropbox.h"
#import "DataSourceFactory.h"
#import "LTHPasscodeViewController.h"
#import "AttributeData.h"

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        
    NSTimeInterval threshold = [LTHPasscodeViewController timerDuration];
    
    if (threshold <= 0)
    {
        [_pinThresholdButton setTitle:NSLocalizedString(@"Auto Lock Immediately", @"") forState:UIControlStateNormal];
    }
    else if (threshold < 60)
    {
        NSString* title = [NSString stringWithFormat: @"Auto Lock After %f Seconds", threshold];
        [_pinThresholdButton setTitle:NSLocalizedString(title, @"") forState:UIControlStateNormal];
    }
    else
    {
        NSString* title = [NSString stringWithFormat: @"Auto Lock After %f Minutes", threshold / 60];
        [_pinThresholdButton setTitle:NSLocalizedString(title, @"") forState:UIControlStateNormal];
    }
    
    if (![LTHPasscodeViewController doesPasscodeExist])
    {
        [self.tableView headerViewForSection:0].textLabel.text = @"Security PIN: OFF";
        _switchPasswordButton.titleLabel.text = @"Turn Security PIN On";
        _updatePasswordButton.enabled = FALSE;
        _pinThresholdButton.enabled = FALSE;
    }
    else
    {
        [self.tableView headerViewForSection:0].textLabel.text = @"Security PIN: ON";
        _switchPasswordButton.titleLabel.text = @"Turn Security PIN Off";
        _updatePasswordButton.enabled = TRUE;
        _pinThresholdButton.enabled = TRUE;
    }
    
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    NSString* datasourceType = [prefs stringForKey:kDatasourceType];
    DBAccount* account = [[DBAccountManager sharedManager] linkedAccount];
    _dropboxSyncSwitch.on = [@"Dropbox" isEqualToString:datasourceType] && account != nil;
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

#pragma mark Mail Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;
{
    long threshold = -1;
    if (buttonIndex == 0)
    {
        threshold = 0;
    }
    else if (buttonIndex == 1)
    {
        threshold = 5;
    }
    else if (buttonIndex == 2)
    {
        threshold = 15;
    }
    else if (buttonIndex == 3)
    {
        threshold = 60;
    }
    else if (buttonIndex == 4)
    {
        threshold = 300;
    }
    else if (buttonIndex == 5)
    {
        threshold = 600;
    }
    else
    {
        //user cancelled
        return;
    }

    [LTHPasscodeViewController saveTimerDuration:threshold];
//    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
//    [prefs setInteger:threshold forKey:kPinThreshold];
//    [prefs synchronize];

    if (threshold <= 0)
    {
        [_pinThresholdButton setTitle:NSLocalizedString(@"Immediately", @"") forState:UIControlStateNormal];
    }
    else if (threshold < 60)
    {
        NSString* title = [NSString stringWithFormat: @"Auto Lock After %ld Seconds", threshold];
        [_pinThresholdButton setTitle:NSLocalizedString(title, @"") forState:UIControlStateNormal];
    }
    else
    {
        NSString* title = [NSString stringWithFormat: @"Auto Lock After %ld Minutes", threshold / 60];
        [_pinThresholdButton setTitle:NSLocalizedString(title, @"") forState:UIControlStateNormal];
    }
}

#pragma mark IBAction

- (IBAction)switchPasscodeButtonTouched:(id)sender
{
    if ([LTHPasscodeViewController doesPasscodeExist]) {
        [[LTHPasscodeViewController sharedUser] showForDisablingPasscodeInViewController:self asModal:NO];
    }
    else {
        [[LTHPasscodeViewController sharedUser] showForEnablingPasscodeInViewController:self asModal:NO];
    }
}

- (IBAction)switchSyncButtonTouched:(id)sender
{
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    if (_dropboxSyncSwitch.on)
    {
        DBAccount* account = [[DBAccountManager sharedManager] linkedAccount];

        [prefs setObject:@"Dropbox" forKey:kDatasourceType];
        [prefs synchronize];

        if (account)
        {
            NSLog(@"App already linked");

            [[DataSourceFactory getDataSource] updateDataStrategy];
        }
        else
        {
            [[DBAccountManager sharedManager] linkFromController:self];

            //comment following line, because this will happen in app delegate.
//            [[DataSourceFactory getDataSource] updateDataStrategy];
        }
    }
    else
    {
        [prefs removeObjectForKey:kDatasourceType];
        [prefs synchronize];
        [[DataSourceFactory getDataSource] updateDataStrategy];
    }
}

- (IBAction)updatePasscodeButtonTouched:(id)sender {
    if ([LTHPasscodeViewController doesPasscodeExist]) {
        [[LTHPasscodeViewController sharedUser] showForChangingPasscodeInViewController:self asModal:NO];
    }
}

- (IBAction)pinThresholdButtonTouched:(id)sender {
    
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Auto Lock", @"")
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:NSLocalizedString(@"Immediately", @""), NSLocalizedString(@"5 seconds", @""), NSLocalizedString(@"15 seconds", @""), NSLocalizedString(@"1 minute", @""), NSLocalizedString(@"5 minutes", @""), NSLocalizedString(@"10 minutes", @""), nil];
    [sheet showInView:self.view];
}

- (IBAction)upgradeButtonTouched:(id)sender {
    //todo: implement IAP here.
}

- (IBAction)exportButtonTouched:(id)sender {
    
    //for security reason, user have to enter passcode before export.
    if ([LTHPasscodeViewController doesPasscodeExist]) 
        if ([LTHPasscodeViewController didPasscodeTimerEnd])
            [[LTHPasscodeViewController sharedUser] showLockScreenWithAnimation:NO
                                                                     withLogout:NO
                                                                 andLogoutTitle:nil];
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Passworld Export"];
//        [mail setToRecipients:@[@"passworld@chenyi.me"]];
        
        NSMutableString* message = [[NSMutableString alloc] init];
        NSArray* estates = [DataSourceFactory getDataSource].estatesByName;
        for (EstateData* data in estates){
            [message appendString:[NSString stringWithFormat:@"Name:%@\n", data.name]];
            for (AttributeData* attrData in data.attributeValues){
                [message appendString:[NSString stringWithFormat:@"-----Name:%@, Value:%@\n", attrData.attrName, attrData.attrValue]];
            }
        }
        [mail setMessageBody:message isHTML:FALSE];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert"  message:@"This device cannot send email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        NSLog(@"This device cannot send email");
    }
}

- (IBAction)mailButtonTouched:(id)sender{
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Passworld Support"];
        [mail setToRecipients:@[@"passworld@chenyi.me"]];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert"  message:@"This device cannot send email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

        NSLog(@"This device cannot send email");
    }
}

- (IBAction)urlButtonTouched:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://github.com/chenyi1976/Passworld/"]];
}


@end
