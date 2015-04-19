//
//  EstateViewController.m
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "EstateViewController.h"
#import "DataSourceFactory.h"
#import "EstateTableViewCell.h"
#import "ConstantDefinition.h"
#import "AttributeData.h"
#import "LTHPasscodeViewController.h"
#import "KeyChainUtil.h"
#import "iToast.h"
#import "AccountViewController.h"
#import "PassworldIAPHelper.h"

@interface EstateViewController ()
    @property NSArray* searchResults;
    @property long sortingType;
    @property AwesomeMenuItem *startItem;
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
    
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    _sortingType = [prefs integerForKey:kSortingBy];
    if (_sortingType <= 0)
        _sortingType = sorting_by_name;
    
    [[DataSourceFactory getDataSource] registerObserver:self];
    
    if (![prefs boolForKey:kWelcomed]) {
        [prefs setBool:true forKey:kWelcomed];
        [prefs synchronize];
        
        NSString* encryptKey = [KeyChainUtil loadFromKeyChainForKey:kEncryptKey];
        
        if (encryptKey == nil)
        {
            NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
            NSMutableString *encryptKey = [NSMutableString stringWithCapacity:18];
            for (NSUInteger i = 0U; i < 18; i++) {
                u_int32_t r = arc4random() % [alphabet length];
                unichar c = [alphabet characterAtIndex:r];
                [encryptKey appendFormat:@"%C", c];
            }
            
            [KeyChainUtil saveToKeyChainForKey:kEncryptKey withValue:encryptKey];
        }
        
        [[LTHPasscodeViewController sharedUser] showForEnablingPasscodeInViewController:self asModal:NO];
    }
    else{
        if ([LTHPasscodeViewController doesPasscodeExist]) {
            if ([LTHPasscodeViewController didPasscodeTimerEnd])
                [[LTHPasscodeViewController sharedUser] showLockScreenWithAnimation:NO
                                                                         withLogout:NO
                                                                     andLogoutTitle:nil];
        }
    }
    
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    
    UIImage *sortByNameMenuImage = [UIImage imageNamed:@"icon-a.png"];
    AwesomeMenuItem *sortByNameMenuItem = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:sortByNameMenuImage
                                                    highlightedContentImage:nil];
    UIImage *sortByNameRevMenuImage = [UIImage imageNamed:@"icon-z.png"];
    AwesomeMenuItem *sortByNameRevMenuItem = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                                highlightedImage:storyMenuItemImagePressed
                                                                    ContentImage:sortByNameRevMenuImage
                                                         highlightedContentImage:nil];
    
    UIImage *sortByUpdateMenuImage = [UIImage imageNamed:@"icon-clock.png"];
    AwesomeMenuItem *sortByUpdateMenuItem = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:sortByUpdateMenuImage
                                                    highlightedContentImage:nil];
    
    UIImage *sortByVisitMenuImage = [UIImage imageNamed:@"icon-quicklook.png"];
    AwesomeMenuItem *sortByVistMenuItem = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:sortByVisitMenuImage
                                                    highlightedContentImage:nil];
    
    NSArray *menus = [NSArray arrayWithObjects:sortByNameMenuItem, sortByNameRevMenuItem, sortByUpdateMenuItem, sortByVistMenuItem, nil];
    
    _startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg-addbutton.png"]
                                                       highlightedImage:[UIImage imageNamed:@"bg-addbutton-highlighted.png"]
                                                           ContentImage:[UIImage imageNamed:@"icon-plus.png"]
                                                highlightedContentImage:[UIImage imageNamed:@"icon-plus-highlighted.png"]];
    
    switch (_sortingType) {
        case sorting_by_name:
            [[_startItem contentImageView] setImage:sortByNameMenuImage];
            break;
        case sorting_by_name_rev:
            [[_startItem contentImageView] setImage:sortByNameRevMenuImage];
            break;
        case sorting_by_update:
            [[_startItem contentImageView] setImage:sortByUpdateMenuImage];
            break;
        case sorting_by_visit:
            [[_startItem contentImageView] setImage:sortByVisitMenuImage];
            break;
            
        default:
            break;
    }
    
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:self.view.bounds startItem:_startItem menuItems:menus];
    menu.delegate = self;
    
    menu.menuWholeAngle = M_PI_2;
    menu.farRadius = 110.0f;
    menu.endRadius = 100.0f;
    menu.nearRadius = 90.0f;
    menu.animationDuration = 0.3f;
//    menu.rotateAngle = - M_PI_2;
    
    menu.startPoint = CGPointMake(50.0, [UIScreen mainScreen].bounds.size.height - 100);
    
    [self.view addSubview:menu];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    _topConstraint.constant = 0;
    
    [_tableView setNeedsUpdateConstraints];
    [_tableView layoutIfNeeded];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AwesomeMenuDelegate

- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx{
    _sortingType = idx;
    
    switch (_sortingType) {
        case sorting_by_name:
            [[iToast makeText:NSLocalizedString(@"Sorting by name.", @"")] show];
            [[_startItem contentImageView] setImage:[UIImage imageNamed:@"icon-a.png"]];
            break;
        case sorting_by_name_rev:
            [[iToast makeText:NSLocalizedString(@"Sorting by name reversely.", @"")] show];
            [[_startItem contentImageView] setImage:[UIImage imageNamed:@"icon-z.png"]];
            break;
        case sorting_by_update:
            [[iToast makeText:NSLocalizedString(@"Sorting by modification.", @"")] show];
            [[_startItem contentImageView] setImage:[UIImage imageNamed:@"icon-clock.png"]];
            break;
        case sorting_by_visit:
            [[iToast makeText:NSLocalizedString(@"Sorting by visiting.", @"")] show];
            [[_startItem contentImageView] setImage:[UIImage imageNamed:@"icon-quicklook.png"]];
            break;
            
        default:
            break;
    }

    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:_sortingType forKey:kSortingBy];
    [prefs synchronize];
    
    
    
    [_tableView reloadData];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        [view setTag:103];
        [view setBackgroundColor:[UIColor blackColor]];
        [view setAlpha:0.8];
        [self.view addSubview:view];
        
        UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
        [activityIndicator setCenter:view.center];
        [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        [view addSubview:activityIndicator];
        
        [activityIndicator startAnimating];
        
        [[PassworldIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
            UIView *view = (UIView *)[self.view viewWithTag:103];
            [view removeFromSuperview];
            
            if (products == nil || [products count] > 0){
                [[iToast makeText:NSLocalizedString(@"Error: IAP not avaiable, please retry.", @"")] show];
            }
            else{
                [[PassworldIAPHelper sharedInstance] buyProduct:[products lastObject]];
                if ([[PassworldIAPHelper sharedInstance] productPurchased:iap_id_pro]){
                    [[iToast makeText:NSLocalizedString(@"Thanks for upgrading.", @"")] show];
                }
            }
        }];
    }
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"CreateAccountSegue"]){
        if ([[self getEstateDatas] count] >= 12){
            if ([[PassworldIAPHelper sharedInstance] productPurchased:iap_id_pro]){
                return TRUE;
            }
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Upgrade to Pro" message:@"Free version only support 12 entries. Upgrade to Pro?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO",nil];
            alert.alertViewStyle=UIAlertViewStyleDefault;
            [alert show];

            return [[PassworldIAPHelper sharedInstance] productPurchased:iap_id_pro];
        }
    }
    return  TRUE;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ModifyAccountSegue"])
    {
        // Get reference to the destination view controller
        AccountViewController *vc = [segue destinationViewController];
        
        EstateData* data;
        if (self.searchDisplayController.active == YES)
        {
            NSArray* estates = _searchResults;
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForCell:sender];
            data = [estates objectAtIndex:indexPath.row];
        }
        else
        {
            NSArray* estates =[self getEstateDatas];
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            data = [estates objectAtIndex:indexPath.row];
        }
        
        [vc updateEstateData:data];
    }
    else if ([[segue identifier] isEqualToString:@"CreateAccountSegue"])
    {
        // Get reference to the destination view controller
        AccountViewController *vc = [segue destinationViewController];
        [vc updateEstateData:nil];
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
    return [[self getEstateDatas] count];
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
    
    EstateData* data = [self getEstateDataByIndexPath:indexPath];
    if (data){
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
            NSMutableArray* newdata = [NSMutableArray arrayWithArray:_searchResults];
            [newdata removeObject:data];
            _searchResults = newdata;
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [_tableView reloadData];
            });
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
        estates =[self getEstateDatas];
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
        return lineCount * 18.0f + 48.0f;
    }
    return 60.0f;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSArray* estates;
//    if (tableView == self.searchDisplayController.searchResultsTableView)
//    {
//        estates = _searchResults;
//    }
//    else
//    {
//        estates =[[DataSourceFactory getDataSource] estatesByName];
//    }
//
//    EstateData* data = [estates objectAtIndex:indexPath.row];
//    if (data)
//    {
////        NSMutableArray* attributeValues = [data attributeValues];
////        if (attributeValues)
////            if ([attributeValues count] > 0)
////            {
//                [self performSegueWithIdentifier:@"ModifyAccountSegue" sender:tableView];
////                return;
////            }
////        [self performSegueWithIdentifier:@"ModifyNoteSegue" sender:tableView];
//    }
//}


#pragma mark - search display delegate

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
    tableView.frame = _tableView.frame;    
}

#pragma mark - Observer

- (void)dataChanged
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        if (self.searchDisplayController.active == YES)
        {
            [self filterContentForSearchText:self.searchDisplayController.searchBar.text
                                       scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                              objectAtIndex:[self.searchDisplayController.searchBar
                                                             selectedScopeButtonIndex]]];

            [self.searchDisplayController.searchResultsTableView reloadData];
        }
        else
        {
            [_tableView reloadData];
        }
    });
}

#pragma mark - Guesture

- (IBAction)handleLongPresss:(id)sender {

    UILongPressGestureRecognizer* gestureRecognizer = sender;
    
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        EstateData* data = [self getEstateDataByIndexPath:indexPath];
        if (data){
            NSMutableString* message = [[NSMutableString alloc] init];
            [message appendString:[NSString stringWithFormat:@"Name:%@\n", data.name]];
            for (AttributeData* attrData in data.attributeValues){
                [message appendString:[NSString stringWithFormat:@"-----Name:%@, Value:%@\n", attrData.attrName, attrData.attrValue]];
            }
            [UIPasteboard generalPasteboard].string = message;
            [[iToast makeText:NSLocalizedString(@"Value Copied!", @"")] show];
        }
    } else {
        NSLog(@"gestureRecognizer.state = %d", gestureRecognizer.state);
    }
}


#pragma mark - IBAction


#pragma mark - Search

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"ANY %K.attrValue contains[c] %@ OR ANY %K.attrName contains[c] %@ OR content contains[c] %@ OR name contains[c] %@", @"attributeValues", searchText, @"attributeValues", searchText, searchText, searchText];
    
    NSArray* estates = [self getEstateDatas];
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

#pragma mark - Interface

-(NSArray*)getEstateDatas{
    NSArray* estates;
    if (_tableView == self.searchDisplayController.searchResultsTableView){
        estates = _searchResults;
    }
    else {
        switch (_sortingType) {
            case sorting_by_name:
                estates =[[DataSourceFactory getDataSource] estatesByName];
                break;
            case sorting_by_name_rev:
                estates =[[DataSourceFactory getDataSource] estatesByNameRev];
                break;
            case sorting_by_update:
                estates =[[DataSourceFactory getDataSource] estatesByUpdate];
                break;
            case sorting_by_visit:
                estates =[[DataSourceFactory getDataSource] estatesByVisit];
                break;
                
            default:
                estates =[[DataSourceFactory getDataSource] estatesByName];
                break;
        }
    }
    return estates;
}


-(EstateData*)getEstateDataByIndexPath:(NSIndexPath*)indexPath{
    NSArray* estates = [self getEstateDatas];
    if (estates && indexPath.row < [estates count])
    {
        EstateData* data = [estates objectAtIndex:indexPath.row];
        return data;
    }
    return nil;
}

@end
