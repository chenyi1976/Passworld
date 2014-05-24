//
//  SettingViewController.h
//  DigitalEstate
//
//  Created by Yi Chen on 29/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UITableViewController<UITableViewDelegate>

@property IBOutlet UIButton* switchPasswordButton;
@property IBOutlet UIButton* updatePasswordButton;
@property IBOutlet UISwitch* dropboxSyncSwitch;

- (IBAction)switchPasscodeButtonTouched:(id)sender;
- (IBAction)switchSyncButtonTouched:(id)sender;

@end
