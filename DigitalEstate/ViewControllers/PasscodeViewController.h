//
//  PasscodeViewController.h
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasscodeViewController : UIViewController

@property IBOutlet UIButton* button0;
@property IBOutlet UIButton* button1;
@property IBOutlet UIButton* button2;
@property IBOutlet UIButton* button3;
@property IBOutlet UIButton* button4;
@property IBOutlet UIButton* button5;
@property IBOutlet UIButton* button6;
@property IBOutlet UIButton* button7;
@property IBOutlet UIButton* button8;
@property IBOutlet UIButton* button9;
@property IBOutlet UIButton* button_nil;
@property IBOutlet UIButton* button_del;

@property IBOutlet UIImageView* light1;
@property IBOutlet UIImageView* light2;
@property IBOutlet UIImageView* light3;
@property IBOutlet UIImageView* light4;


- (IBAction)codeButtonTouched:(id)sender;

@end
