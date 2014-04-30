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
#import "EstateTableViewCell.h"

@interface EstateViewController ()
    @property NSArray* searchResults;
@end

@implementation EstateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [[DataSourceFactory getDataSource] registerObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ModifySegue"])
    {
        // Get reference to the destination view controller
        EstateDetailViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        NSArray* estates =[[DataSourceFactory getDataSource] getEstates];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        EstateData* data = [estates objectAtIndex:indexPath.row];

        [vc setEstateData:data];
    }
    else if ([[segue identifier] isEqualToString:@"CreateSegue"])
    {
        // Get reference to the destination view controller
        EstateDetailViewController *vc = [segue destinationViewController];
        
        [vc setEstateData:nil];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        if (!_searchResults)
            return 0;
        return [_searchResults count];
    }
    return [[[DataSourceFactory getDataSource] getEstates] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyCellIdentifier = @"EstateCell";
    EstateTableViewCell* result = [self.tableView dequeueReusableCellWithIdentifier:MyCellIdentifier];
    
    if (result == nil){
        result = [[EstateTableViewCell alloc]
                  initWithStyle:UITableViewCellStyleDefault
                  reuseIdentifier:MyCellIdentifier];
    }
    
    NSArray* estates;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        estates = _searchResults;
    }
    else
    {
        estates =[[DataSourceFactory getDataSource] getEstates];
    }
    
    if (estates && indexPath.row < [estates count])
    {
        EstateData* data = [estates objectAtIndex:indexPath.row];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
        NSString *strDate = [dateFormatter stringFromDate:data.lastUpdate];
        
        result.dateLabel.text = strDate;
        result.contentLabel.text = data.content;
    }
    else
    {
        result.contentLabel.text = [NSString stringWithFormat:@"Section %ld, Cell %ld",
                                    (long)indexPath.section,
                                    (long)indexPath.row];
    }
    result.accessoryType = UITableViewCellAccessoryNone;

    return result;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[DataSourceFactory getDataSource] removeObjectAtIndex:indexPath.row];
    }
}

#pragma mark - table delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

#pragma mark - search display delegate

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
    tableView.frame = _tableView.frame;    
}

#pragma mark - Observer

- (void)dataChanged
{
    [_tableView reloadData];
}

#pragma mark - IBAction

- (IBAction)audioButtonTouched:(id)sender
{
    
}

- (IBAction)cameraButtonTouched:(id)sender
{
    
}

- (IBAction)videoButtonTouched:(id)sender
{
    
}

- (IBAction)textButtonTouched:(id)sender
{
    
}

- (IBAction)switchButtonTouched:(id)sender
{
    CGFloat y = _buttonView.frame.origin.y;
    NSLog(@"y: %f", y);
    if (y < 50)//y location after expanded
        y = y + _buttonView.frame.size.height;
    else
        y = y - _buttonView.frame.size.height;
    [UIView animateWithDuration:0.5f animations:^(void){
        NSLog(@"animation!!");
        NSLog(@"new value y: %f", y);
        [_buttonView setFrame:CGRectMake(_buttonView.frame.origin.x, y, _buttonView.frame.size.width, _buttonView.frame.size.height)];
        [_tableView setFrame:CGRectMake(_buttonView.frame.origin.x, y + _buttonView.frame.size.height, _buttonView.frame.size.width, self.view.frame.size.height -  y - _buttonView.frame.size.height)];
    }];
}


#pragma mark - Search

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"content contains[c] %@", searchText];
    
    NSArray* estates =[[DataSourceFactory getDataSource] getEstates];
    _searchResults = [estates filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}


@end
