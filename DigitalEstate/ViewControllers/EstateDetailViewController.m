//
//  EstateDetailViewController.m
//  DigitalEstate
//
//  Created by Yi Chen on 18/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "EstateDetailViewController.h"
#import "DataSourceFactory.h"

@interface EstateDetailViewController ()

@end

@implementation EstateDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBAction

- (IBAction)deleteButtonTouched:(id)sender
{
    NSLog(@"delete button");
}

- (IBAction)saveButtonTouched:(id)sender
{
    EstateData* data = [[EstateData alloc] initWithName:_nameTextView.text Content:_estateTextView.text];
    [[DataSourceFactory getDataSource] addObject:data];
}

- (IBAction)editButtonTouched:(id)sender
{
    if (data)
    {
        [_nameTextView setEnabled:TRUE];
        [_estateTextView setEditable:TRUE];
        [_nameTextView becomeFirstResponder];
    }
}

#pragma mark business method

EstateData* data;

- (void)setEstateData:(EstateData*)estate
{
    data = estate;
    [_nameTextView setText:estate.name];
    [_estateTextView setText:estate.content];
}

@end
