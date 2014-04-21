//
//  EstateViewController.m
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "EstateViewController.h"
#import "DataSourceFactory.h"
#import "EstateDetailViewController.h"

@interface EstateViewController ()

@end

@implementation EstateViewController

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
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"CreateSegue"]
        || [[segue identifier] isEqualToString:@"ModifySegue"])
    {
        // Get reference to the destination view controller
        EstateDetailViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        NSArray* estates =[[DataSourceFactory getDataSource] getEstates];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        EstateData* data = [estates objectAtIndex:indexPath.row];

        [vc setEstateData:data];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[DataSourceFactory getDataSource] getEstates] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* result = nil;
    if (tableView == _tableView)
    {
        static NSString *MyCellIdentifier = @"EstateCell";
        result = [tableView dequeueReusableCellWithIdentifier:MyCellIdentifier];
        if (result == nil){
            result = [[UITableViewCell alloc]
                      initWithStyle:UITableViewCellStyleDefault
                      reuseIdentifier:MyCellIdentifier];
        }
    NSArray* estates =[[DataSourceFactory getDataSource] getEstates];
    if (indexPath.row < [estates count])
    {
        EstateData* data = [estates objectAtIndex:indexPath.row];
        result.textLabel.text = [NSString stringWithFormat:data.name,
                                 (long)indexPath.section,
                                 (long)indexPath.row];
    }
    else
    {
        result.textLabel.text = [NSString stringWithFormat:@"Section %ld, Cell %ld",
                                 (long)indexPath.section,
                                 (long)indexPath.row];
    }
        result.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    return result;
}

#pragma mark - business logic


@end
