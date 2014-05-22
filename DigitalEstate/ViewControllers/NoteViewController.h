//
//  EstateDetailViewController.h
//  DigitalEstate
//
//  Created by Yi Chen on 18/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EstateData.h"
#import "EstateDataSource.h"
#import "DetailViewController.h"

@interface NoteViewController : DetailViewController

@property IBOutlet UIButton* deleteButton;
@property IBOutlet UITextField* nameTextView;
@property IBOutlet UITextView* estateTextView;

- (IBAction)backButtonTouched:(id)sender;
- (IBAction)okButtonTouched:(id)sender;
- (IBAction)deleteButtonTouched:(id)sender;
- (IBAction)historyButtonTouched:(id)sender;

@end
