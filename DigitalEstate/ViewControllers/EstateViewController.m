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
    [prefs setBool:true forKey:kWelcomed];
    [prefs synchronize];
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
            estates =[[DataSourceFactory getDataSource] getEstates];
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
        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
//        NSString *strDate = [dateFormatter stringFromDate:data.lastUpdate];
        
        if (data.name == nil || [data.name length] == 0)
        {
            if ([data.attributeValues count] > 0)
            {
                result.nameLabel.text = @"Account";
            }
            else
            {
                result.nameLabel.text = @"Note";
            }
        }
        else
        {
            result.nameLabel.text = data.name;
        }
        if (data.content == nil || [data.content length] == 0)
        {
            if ([data.attributeValues count] > 0)
            {
                result.contentLabel.numberOfLines = [data.attributeValues count] * 2;

                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
                UIFont* smallFont = [UIFont systemFontOfSize:12.f];
                UIColor* lightBlueColor = [UIColor colorWithRed:0x22/255.0f green:0x22/255.0f blue:0x99/255.0f alpha:1];
                
                bool isFirst = TRUE;
                
                for (AttributeData* attributeData in data.attributeValues)
                {
                    if (!isFirst)
                    {
                        [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
                    }
                    isFirst = FALSE;
                    NSString * attrName = attributeData.attrName;
                    if (attrName.length > 23)
                    {
                        attrName = [NSString stringWithFormat:@"%@...", [attrName substringToIndex:20]];
                    }
                    NSAttributedString* attrNameStr = [[NSAttributedString alloc] initWithString:attrName attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:smallFont}];
                    [attributedText appendAttributedString:attrNameStr];

                    [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
                    
                    NSString * attrValue = attributeData.attrValue;
                    if (attrValue.length > 23)
                    {
                        attrValue = [NSString stringWithFormat:@"%@...", [attrValue substringToIndex:20]];
                    }
                    NSAttributedString* attrValueStr = [[NSAttributedString alloc] initWithString:attributeData.attrValue attributes:@{NSForegroundColorAttributeName:lightBlueColor}];
                    [attributedText appendAttributedString:attrValueStr];
                }
                result.contentLabel.attributedText = attributedText;
            }
            else
            {
                result.contentLabel.numberOfLines = 1;
                result.contentLabel.text =  @"";
            }
        }
        else
        {
            int lineCount = data.content.length / 22;
            result.contentLabel.numberOfLines = lineCount > 4? 4 : lineCount;
            result.contentLabel.text =  data.content;
        }
        [result.iconView setImage: [data.attributeValues count] == 0 ? [UIImage imageNamed:@"circle_text.png"]: [UIImage imageNamed:@"password.png"] ];
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
        int lineCount = data.attributeValues.count;
        if (data.content != nil && data.content.length > 0)
        {
            lineCount = data.content.length / 22;
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
        estates =[[DataSourceFactory getDataSource] getEstates];
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
    [_tableView reloadData];
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
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"ANY %K.attrValue contains[c] %@ OR ANY %K.attrName contains[c] %@ OR content contains[c] %@ ", @"attributeValues", searchText, @"attributeValues", searchText, searchText];
    
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
