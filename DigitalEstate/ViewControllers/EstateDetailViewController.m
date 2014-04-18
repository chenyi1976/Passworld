//
//  EstateDetailViewController.m
//  DigitalEstate
//
//  Created by Yi Chen on 18/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "EstateDetailViewController.h"

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark IBAction

- (IBAction)deleteButtonTouched:(id)sender
{
    NSLog(@"delete button");
}

- (IBAction)saveButtonTouched:(id)sender
{
    NSLog(@"save button");
}

- (IBAction)editButtonTouched:(id)sender
{
    NSLog(@"edit button");
}

#pragma mark business method
- (void)setEstateData:(EstateData*)estate
{
    [_estateTextView setText:estate.content];
}

@end
