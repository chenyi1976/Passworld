//
//  RecordViewController.m
//  DigitalEstate
//
//  Created by Yi Chen on 13/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountTableViewCell.h"
#import "EstateData.h"

@interface AccountViewController ()
    @property NSMutableDictionary* tableData;
@end

@implementation AccountViewController

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
    _tableData = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"", @"Account Name", @"", @"Password", nil];
    [_tableView setDataSource:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyCellIdentifier = @"AccountCell";
    AccountTableViewCell* result = [self.tableView dequeueReusableCellWithIdentifier:MyCellIdentifier];
    
    if (result == nil){
        result = [[AccountTableViewCell alloc]
                  initWithStyle:UITableViewCellStyleDefault
                  reuseIdentifier:MyCellIdentifier];
    }
    
    return result;
}


#pragma mark IBAction

- (IBAction)okButtonTouched:(id)sender
{
    [self dismissViewControllerAnimated:TRUE completion:^(void){}];
}

- (IBAction)backButtonTouched:(id)sender
{
    [self dismissViewControllerAnimated:TRUE completion:^(void){}];
}

- (IBAction)addLineButtonTouched:(id)sender
{
    NSLog(@"addLineButtonTouched");
}

- (IBAction)deleteButtonTouched:(id)sender
{
    NSLog(@"deleteButtonTouched");
}

@end
