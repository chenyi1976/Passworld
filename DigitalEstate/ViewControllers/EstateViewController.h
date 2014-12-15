//
//  EstateViewController.h
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EstateDataSource.h"
#import "Observer.h"

@interface EstateViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, Observer>

@property IBOutlet UITableView * tableView;
//@property IBOutlet UIView * buttonView;
//@property IBOutlet UIBarButtonItem * switchButton;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

//- (IBAction)audioButtonTouched:(id)sender;
//- (IBAction)cameraButtonTouched:(id)sender;
//- (IBAction)videoButtonTouched:(id)sender;
//- (IBAction)textButtonTouched:(id)sender;

//- (IBAction)switchButtonTouched:(id)sender;

@end
