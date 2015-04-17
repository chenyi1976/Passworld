//
//  RecordViewController.h
//  DigitalEstate
//
//  Created by Yi Chen on 13/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EstateData.h"

@interface AccountViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIActionSheetDelegate>


@property (weak, nonatomic) IBOutlet UITextField* nameTextField;
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (weak, nonatomic) IBOutlet UIButton* deleteButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *okButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomConstraint;

- (IBAction)backButtonTouched:(id)sender;
- (IBAction)okButtonTouched:(id)sender;
- (IBAction)deleteButtonTouched:(id)sender;
- (IBAction)tableCellTouched:(id)sender;

- (void)updateEstateData:(EstateData*)data;


@end
