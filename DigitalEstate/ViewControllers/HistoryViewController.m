//
//  HistoryViewController.m
//  DigitalEstate
//
//  Created by Yi Chen on 12/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
    @property NSArray* searchResults;
@end

@implementation HistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (tableView == self.searchDisplayController.searchResultsTableView)
//    {
//        if (!_searchResults)
//            return 0;
//        return [_searchResults count];
//    }
//    return [[[DataSourceFactory getDataSource] getEstates] count];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *MyCellIdentifier = @"EstateCell";
//    EstateTableViewCell* result = [self.tableView dequeueReusableCellWithIdentifier:MyCellIdentifier];
//    
//    if (result == nil){
//        result = [[EstateTableViewCell alloc]
//                  initWithStyle:UITableViewCellStyleDefault
//                  reuseIdentifier:MyCellIdentifier];
//    }
//    
//    NSArray* estates;
//    if (tableView == self.searchDisplayController.searchResultsTableView)
//    {
//        estates = _searchResults;
//    }
//    else
//    {
//        estates =[[DataSourceFactory getDataSource] getEstates];
//    }
//    
//    if (estates && indexPath.row < [estates count])
//    {
//        EstateData* data = [estates objectAtIndex:indexPath.row];
//        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
//        NSString *strDate = [dateFormatter stringFromDate:data.lastUpdate];
//        
//        result.dateLabel.text = strDate;
//        result.contentLabel.text = data.content;
//    }
//    else
//    {
//        result.contentLabel.text = [NSString stringWithFormat:@"Section %ld, Cell %ld",
//                                    (long)indexPath.section,
//                                    (long)indexPath.row];
//    }
//    result.accessoryType = UITableViewCellAccessoryNone;
//    
//    return result;
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [[DataSourceFactory getDataSource] removeObjectAtIndex:indexPath.row];
//    }
}

#pragma mark - table delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

#pragma mark - Search

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
//    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"content contains[c] %@", searchText];
//    
//    NSArray* estates =[[DataSourceFactory getDataSource] getEstates];
//    _searchResults = [estates filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

#pragma mark IBAction

- (IBAction)backButtonTouched:(id)sender
{
    [self dismissViewControllerAnimated:TRUE completion:^(void){}];
}

#pragma mark business logic

EstateData* data;

- (void)setEstateData:(EstateData*)estate
{
    data = estate;
//    if (data)
//        [_estateTextView setText:data.content];
//    else
//        [_estateTextView setText:@""];
}



@end
