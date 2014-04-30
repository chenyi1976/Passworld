//
//  SettingViewController.h
//  DigitalEstate
//
//  Created by Yi Chen on 29/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UITableViewDelegate>

@property IBOutlet UITableView* tableView;

- (IBAction)closeButtonTouched:(id)sender;

@end
