//
//  RegistrationViewController.h
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController

@property IBOutlet UIButton* countryButton;
@property IBOutlet UITextField* countryField;
@property IBOutlet UITextField* phoneField;
@property IBOutlet UITextField* codeField;
@property IBOutlet UILabel* phoneNoLabel;

- (IBAction)requestButtonClicked:(id)sender;
- (IBAction)verifyButtonClicked:(id)sender;

@end
