//
//  AccountTableViewCell.h
//  DigitalEstate
//
//  Created by Yi Chen on 14/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttributeData.h"

@interface AccountTableViewCell : UITableViewCell<UITextFieldDelegate>

@property IBOutlet UITextField* nameTextField;
@property IBOutlet UITextField* valueTextField;

- (IBAction)deleteButtonClicked:(id)sender;


@end
