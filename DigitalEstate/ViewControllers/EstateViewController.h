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

-(EstateData*)getEstateDataByIndexPath:(NSIndexPath*)indexPath;

@end
