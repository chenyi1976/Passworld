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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_estateTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBAction

- (IBAction)deleteButtonTouched:(id)sender
{
    if (data != nil)
    {
        [data setContent:_estateTextView.text];
        [[DataSourceFactory getDataSource] removeObject:data];
    }
    [self dismissViewControllerAnimated:TRUE completion:^(void){}];
}

- (IBAction)okButtonTouched:(id)sender
{
    if (data == nil)
    {
        EstateData* data = [[EstateData alloc] initWithName:@"" Content:_estateTextView.text];
        [[DataSourceFactory getDataSource] addObject:data];
    }
    else
    {
        NSUInteger index = [[DataSourceFactory getDataSource] indexOfObject:data];
        [data setContent:_estateTextView.text];
        [[DataSourceFactory getDataSource] replaceObjectAtIndex:index withObject:data];
    }
    [self dismissViewControllerAnimated:TRUE completion:^(void){}];
}

- (IBAction)backButtonTouched:(id)sender
{
    [self dismissViewControllerAnimated:TRUE completion:^(void){}];
}

#pragma mark business method

EstateData* data;

- (void)setEstateData:(EstateData*)estate
{
    data = estate;
    if (data)
        [_estateTextView setText:data.content];
    else
        [_estateTextView setText:@""];
}

@end
