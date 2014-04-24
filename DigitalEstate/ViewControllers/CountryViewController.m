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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[DiallingCodesUtil sharedInstance] getCountryNames].count;
}

#pragma mark - Overwrite

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CountryCell" forIndexPath:indexPath];
    
    DiallingCodesUtil* diallingCodesUtil = [DiallingCodesUtil sharedInstance];
    NSArray* countries = [diallingCodesUtil getCountryNames];
    if (indexPath.row >= 0 && indexPath.row < countries.count)
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
    NSUInteger row = [self.tableView indexPathForSelectedRow].row;
    
    NSUserDefaults* perf = [NSUserDefaults standardUserDefaults];
    NSArray* countryCodes = [[DiallingCodesUtil sharedInstance] getCountryCodes];
    [perf setObject:[countryCodes objectAtIndex:row] forKey:kCountryCode];
    [perf synchronize];
    
    [self.navigationController popViewControllerAnimated:TRUE];
}

@end
