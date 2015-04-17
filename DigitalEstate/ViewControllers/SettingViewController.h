//
//  SettingViewController.h
//  DigitalEstate
//
//  Created by Yi Chen on 29/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SettingViewController : UITableViewController<UITableViewDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIButton* switchPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton* updatePasswordButton;
@property (weak, nonatomic) IBOutlet UISwitch* dropboxSyncSwitch;
@property (weak, nonatomic) IBOutlet UIButton *pinThresholdButton;
@property (weak, nonatomic) IBOutlet UIButton *upgradeButton;

- (IBAction)switchPasscodeButtonTouched:(id)sender;
- (IBAction)switchSyncButtonTouched:(id)sender;
- (IBAction)mailButtonTouched:(id)sender;
- (IBAction)pinThresholdButtonTouched:(id)sender;

@end
