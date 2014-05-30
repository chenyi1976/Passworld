//
//  EstateDetailViewController.m
//  DigitalEstate
//
//  Created by Yi Chen on 18/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "NoteViewController.h"
#import "DataSourceFactory.h"
#import "HistoryViewController.h"

@interface NoteViewController ()

@end

@implementation NoteViewController

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
    if (estateData)
    {
        [_nameTextView setText:estateData.name];
        [_estateTextView setText:estateData.content];
    }
    else
    {
        [_nameTextView setText:@""];
        [_estateTextView setText:@""];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [_estateTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBAction

- (IBAction)deleteButtonTouched:(id)sender
{
    if (estateData != nil)
    {
        [estateData setContent:_estateTextView.text];
        [[DataSourceFactory getDataSource] removeObject:estateData];
    }
    [self dismissViewControllerAnimated:TRUE completion:^(void){}];
}

- (IBAction)historyButtonTouched:(id)sender
{
    if (estateData != nil)
    {
        [self performSegueWithIdentifier:@"historySegue" sender:nil];
    }
}

- (IBAction)okButtonTouched:(id)sender
{
    if (estateData == nil)
    {
        NSDate* date = [NSDate date];
        NSString* estateId = [NSString stringWithFormat:@"%@", date];
        
        EstateData* data = [[EstateData alloc] initWithId:estateId withName:_nameTextView.text withContent:_estateTextView.text withAttributeValues:nil  withLastUpdate:[NSDate date] withHistory:nil withDeleted:false];
        [[DataSourceFactory getDataSource] addObject:data];
    }
    else
    {
        NSUInteger index = [[DataSourceFactory getDataSource] indexOfObject:estateData];
        [estateData setName:_nameTextView.text];
        [estateData setContent:_estateTextView.text];
        [[DataSourceFactory getDataSource] replaceObjectAtIndex:index withObject:estateData];
    }
    [self dismissViewControllerAnimated:TRUE completion:^(void){}];
}

- (IBAction)backButtonTouched:(id)sender
{
    [self dismissViewControllerAnimated:TRUE completion:^(void){}];
}

#pragma mark segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"historySegue"])
    {
        // Get reference to the destination view controller
        HistoryViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setEstateData:estateData];
    }
}

@end
