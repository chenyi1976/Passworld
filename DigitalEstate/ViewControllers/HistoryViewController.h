//
//  HistoryViewController.h
//  DigitalEstate
//
//  Created by Yi Chen on 12/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EstateData.h"

@interface HistoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>

@property IBOutlet UITableView * tableView;

- (void)setEstateData:(EstateData*)estate;

- (IBAction)backButtonTouched:(id)sender;

@end
