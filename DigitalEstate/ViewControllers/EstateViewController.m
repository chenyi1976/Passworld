//
//  EstateViewController.m
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "EstateViewController.h"
#import "DataSourceFactory.h"
#import "NoteViewController.h"
#import "EstateTableViewCell.h"
#import "ConstantDefinition.h"
#import "AttributeData.h"

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

    [[DataSourceFactory getDataSource] registerObserver:self];
    
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    if (![prefs boolForKey:kWelcomed])
    {
        [prefs setBool:true forKey:kWelcomed];
        [prefs synchronize];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _topConstraint.constant = 0;
    
    [_tableView setNeedsUpdateConstraints];
    [_tableView layoutIfNeeded];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ModifyNoteSegue"]
        || [[segue identifier] isEqualToString:@"ModifyAccountSegue"])
    {
        // Get reference to the destination view controller
        DetailViewController *vc = [segue destinationViewController];
        
        NSArray* estates;
        if (sender == self.searchDisplayController.searchResultsTableView)
        {
            estates = _searchResults;
        }
        else
        {
            estates =[[DataSourceFactory getDataSource] estatesByName];
        }
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        EstateData* data = [estates objectAtIndex:indexPath.row];

        [vc setEstateData:data];
    }
    else if ([[segue identifier] isEqualToString:@"CreateAccountSegue"]
             || [[segue identifier] isEqualToString:@"CreateNoteSegue"])
    {
        // Get reference to the destination view controller
        NoteViewController *vc = [segue destinationViewController];
        
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
    return [[[DataSourceFactory getDataSource] estatesByName] count];
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
        estates =[[DataSourceFactory getDataSource] estatesByName];
    }
    
    if (estates && indexPath.row < [estates count])
    {
        EstateData* data = [estates objectAtIndex:indexPath.row];
        [result configureForEstateData:data];
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
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        EstateData* data = [_searchResults objectAtIndex:indexPath.row];
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [[DataSourceFactory getDataSource] removeObject:data];
        }
   }
    else
    {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [[DataSourceFactory getDataSource] removeObjectAtIndex:indexPath.row];
        }
    }
}

#pragma mark - table delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* estates;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        estates = _searchResults;
    }
    else
    {
        estates =[[DataSourceFactory getDataSource] estatesByName];
    }
    
    if (estates && indexPath.row < [estates count])
    {
        EstateData* data = [estates objectAtIndex:indexPath.row];
        NSUInteger lineCount = data.attributeValues.count;
        if (data.content != nil && data.content.length > 0)
        {
            lineCount = data.content.length / 22 + 1;
            if (lineCount > 4)
                lineCount = 4;
        }
        return lineCount * 34.0f + 48.0f;
    }
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* estates;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        estates = _searchResults;
    }
    else
    {
        estates =[[DataSourceFactory getDataSource] estatesByName];
    }

    EstateData* data = [estates objectAtIndex:indexPath.row];
    if (data)
    {
        NSMutableArray* attributeValues = [data attributeValues];
        if (attributeValues)
            if ([attributeValues count] > 0)
            {
                [self performSegueWithIdentifier:@"ModifyAccountSegue" sender:tableView];
                return;
            }
        [self performSegueWithIdentifier:@"ModifyNoteSegue" sender:tableView];
    }
}


#pragma mark - search display delegate

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
    tableView.frame = _tableView.frame;    
}

#pragma mark - Observer

- (void)dataChanged
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [_tableView reloadData];
    });
}

#pragma mark - IBAction

- (IBAction)audioButtonTouched:(id)sender
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Audio NOT implemented." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    alert.alertViewStyle=UIAlertViewStyleDefault;
    [alert show];
}

- (IBAction)cameraButtonTouched:(id)sender
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Photo NOT implemented." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    alert.alertViewStyle=UIAlertViewStyleDefault;
    [alert show];
}

- (IBAction)videoButtonTouched:(id)sender
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Video NOT implemented." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    alert.alertViewStyle=UIAlertViewStyleDefault;
    [alert show];
}

- (IBAction)textButtonTouched:(id)sender
{
    
}

- (IBAction)switchButtonTouched:(id)sender
{
    if (_topConstraint.constant <= 0)
        _topConstraint.constant = _buttonView.frame.size.height;
    else
        _topConstraint.constant = 0;
    
    [_tableView setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.5f animations:^(void){
        [_tableView layoutIfNeeded];
    } completion:^(BOOL finished){
    }];
}

#pragma mark - Search

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"ANY %K.attrValue contains[c] %@ OR ANY %K.attrName contains[c] %@ OR content contains[c] %@ OR name contains[c] %@", @"attributeValues", searchText, @"attributeValues", searchText, searchText, searchText];
    
    NSArray* estates =[[DataSourceFactory getDataSource] estatesByName];
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
