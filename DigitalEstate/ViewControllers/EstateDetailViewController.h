//
//  EstateDetailViewController.h
//  DigitalEstate
//
//  Created by Yi Chen on 18/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EstateData.h"

@interface EstateDetailViewController : UIViewController

@property IBOutlet UIButton* deleteButton;
@property IBOutlet UITextView* estateTextView;

- (void)setEstateData:(EstateData*)estate;

- (IBAction)deleteButtonTouched:(id)sender;
- (IBAction)saveButtonTouched:(id)sender;
- (IBAction)editButtonTouched:(id)sender;

@end
