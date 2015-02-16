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


//- (void)viewWillDisappear:(BOOL)animated{
//    NSLog(@"viewWillDisappear");
//    [super viewWillDisappear:animated];
//}
//
//- (void)viewDidDisappear:(BOOL)animated{
//    NSLog(@"viewDidDisappear");
//    [super viewDidDisappear:animated];
//}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    long pass1 = [prefs integerForKey:kPassword1];
    long pass2 = [prefs integerForKey:kPassword2];
    long pass3 = [prefs integerForKey:kPassword3];
    long pass4 = [prefs integerForKey:kPassword4];

    long threshold = [prefs integerForKey:kPinThreshold];
    
    if (threshold <= 0)
    {
        [_pinThresholdButton setTitle:@"Auto Lock Immediately" forState:UIControlStateNormal];
    }
    else if (threshold < 60)
    {
        [_pinThresholdButton setTitle:[NSString stringWithFormat: @"Auto Lock After %ld Seconds", threshold] forState:UIControlStateNormal];
    }
    else
    {
        [_pinThresholdButton setTitle:[NSString stringWithFormat: @"Auto Lock After %ld Minutes", threshold / 60] forState:UIControlStateNormal];
    }
    
    if (pass1 == 0 && pass2 == 0 && pass3 == 0 && pass4 ==0)
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

    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:threshold forKey:kPinThreshold];
    [prefs synchronize];

    if (threshold <= 0)
    {
        [_pinThresholdButton setTitle:@"Auto Lock Immediately" forState:UIControlStateNormal];
    }
    else if (threshold < 60)
    {
        [_pinThresholdButton setTitle:[NSString stringWithFormat: @"Auto Lock After %ld Seconds", threshold] forState:UIControlStateNormal];
    }
    else
    {
        [_pinThresholdButton setTitle:[NSString stringWithFormat: @"Auto Lock After %ld Minutes", threshold / 60] forState:UIControlStateNormal];
    }
}

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

- (IBAction)pinThresholdButtonTouched:(id)sender {
    
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"Auto Lock"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@"Immediately", @"5 seconds", @"15 seconds", @"1 minutes", @"5 minutes", @"10 minutes", nil];
    [sheet showInView:self.view];
}

- (IBAction)mailButtonTouched:(id)sender{
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"SafePass Support"];
        [mail setToRecipients:@[@"safepassapp@chenyi.me"]];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert"  message:@"This device cannot send email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

        NSLog(@"This device cannot send email");
    }
}


@end
