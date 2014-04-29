//
//  CountryViewController.m
//  DigitalEstate
//
//  Created by Yi Chen on 24/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "CountryViewController.h"
#import "DiallingCodesUtil.h"
#import "ConstantDefinition.h"

@interface CountryViewController ()
    @property NSArray* searchResults;
@end

@implementation CountryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (section == 0) {
            return 0;
        }
        if (!_searchResults)
            return 0;
        return [_searchResults count];
    }
    else
    {
        if (section == 0) {
            return [[[DiallingCodesUtil sharedInstance] getMostPopularCountryNames] count];
        }
        return [[DiallingCodesUtil sharedInstance] getCountryNames].count;
    }
}

#pragma mark - Overwrite

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CountryCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CountryCell"];
    }
    DiallingCodesUtil* diallingCodesUtil = [DiallingCodesUtil sharedInstance];
    NSArray* countries;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        if (indexPath.section != 0)
        {
            countries = _searchResults;
        }
    }
    else
    {
        if (indexPath.section == 0)
        {
            countries = [diallingCodesUtil getMostPopularCountryNames];
        }
        else
        {
            countries = [diallingCodesUtil getCountryNames];
        }
    }
    
    if (countries && indexPath.row >= 0 && indexPath.row < countries.count)
    {
        NSString* countryName = [countries objectAtIndex:indexPath.row];
        NSString* dialCode = [[DiallingCodesUtil sharedInstance] getDiallingCodeForCountryName:countryName];
        cell.textLabel.text = countryName;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"+%@", dialCode];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    DiallingCodesUtil* diallingCodesUtil = [DiallingCodesUtil sharedInstance];
    NSArray* countryNames;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        countryNames = _searchResults;
    }
    else
    {
        if (indexPath.section == 0)
        {
            countryNames = [diallingCodesUtil getMostPopularCountryNames];
        }
        else
        {
            countryNames = [diallingCodesUtil getCountryNames];
        }
    }
    
    if (indexPath.row < 0 || indexPath.row >= countryNames.count)
    {
        return;
    }

    NSString* countryCode = [diallingCodesUtil getCountryCodeForName:[countryNames objectAtIndex:indexPath.row]];
    
    NSUserDefaults* perf = [NSUserDefaults standardUserDefaults];
    [perf setObject:countryCode forKey:kCountryCode];
    [perf synchronize];
    
    [self.navigationController popViewControllerAnimated:TRUE];
}

#pragma mark - Search

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self contains[c] %@", searchText];
    _searchResults = [[[DiallingCodesUtil sharedInstance] getCountryNames] filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

#pragma mark - search display delegate

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
//    tableView.frame = _tableView.frame;
}



@end
