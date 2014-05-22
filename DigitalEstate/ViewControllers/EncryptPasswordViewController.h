//
//  EncryptPasswordViewController.h
//  DigitalEstate
//
//  Created by Yi Chen on 1/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EncryptPasswordViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>

@property IBOutlet UITextField* passwordField1;
@property IBOutlet UITextField* passwordField2;

- (IBAction)confirmButtonTouched:(id)sender;
- (IBAction)skipButtonTouched:(id)sender;
- (IBAction)cancelButtonTouched:(id)sender;

@end
