//
//  EstateViewController.m
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "EstateViewController.h"
#import "EstateDataSource.h"
#import "DataSourceFactory.h"

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource

id<EstateDataSource> datasource = nil;

- (id<EstateDataSource>) getDataSource
{
    if (datasource == nil)
    {
        datasource = [[DataSourceFactory sharedInstance] getDataSource:kMockKey];
    }
    return datasource;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self getDataSource] getEstates] count];
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
    NSArray* estates =[[self getDataSource] getEstates];
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


@end
