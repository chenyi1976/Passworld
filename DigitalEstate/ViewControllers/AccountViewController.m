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
#import "ConstantDefinition.h"
#import "AttributeData.h"
#import "DataSourceFactory.h"

@interface AccountViewController ()

@property NSMutableArray* tableData;
//@property(nonatomic) EstateData* estateData;

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
    if (estateData)
    {
        [_nameTextField setText:estateData.name];
        _tableData = [[NSMutableArray alloc] initWithArray:estateData.attributeValues copyItems:TRUE];
    }
    else
    {
        [_nameTextField setText:@""];
        AttributeData* accountNameData = [[AttributeData alloc] initWithId:kAttributeAccountName name:@"Account Name" value:@""];
        AttributeData* accountValueData = [[AttributeData alloc] initWithId:kAttributeAccountValue name:@"Account Value" value:@""];
        
        _tableData = [NSMutableArray arrayWithObjects:accountNameData, accountValueData, nil];
    }
    [_tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) dismissAnyKeyboard:(UIView*)view {
	NSArray *subviews = [view subviews];
	for (UIView *subview in subviews) {
		if ([subview isKindOfClass: [UITextField class]]) {
			UITextField *textfield = (UITextField *)subview;
			if ([textfield isEditing]) {
				[textfield resignFirstResponder];
			}
		}
        else
        {
            [self dismissAnyKeyboard:subview];
        }
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if (![[touch view] isKindOfClass:[UITextField class]])
    {
        [self dismissAnyKeyboard:self.view];
    }
    [super touchesBegan:touches withEvent:event];
}

#pragma mark Keyboard Observer

-(void) keyboardWillShow:(NSNotification *)notification
{
    _tableBottomConstraint.constant = 170;
}

- (void) keyboardWillHide:(NSNotification *)notification
{
    _tableBottomConstraint.constant = 8;
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
    
    AttributeData* data = [_tableData objectAtIndex:indexPath.row];
    if (data)
    {
        [result configureAttributeData:data];
    }
    
    return result;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_tableData removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleNone) {
        AccountTableViewCell* cell = (AccountTableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
        
        AttributeData* data = [[AttributeData alloc] initWithId:kAttributeAccountName name:cell.nameTextField.text value:cell.valueTextField.text];
        [_tableData replaceObjectAtIndex:indexPath.row withObject:data];
        [_tableView reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    UITableViewCell *cell;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        cell = (UITableViewCell *) textField.superview.superview;
        
    } else {
        // Load resources for iOS 7 or later
        cell = (UITableViewCell *) textField.superview.superview.superview;
        // TextField -> UITableVieCellContentView -> (in iOS 7!)ScrollView -> Cell!
    }
    [_tableView scrollToRowAtIndexPath:[_tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark IBAction

- (IBAction)okButtonTouched:(id)sender
{
//    [self dismissAnyKeyboard:self.view];
    [[self view] endEditing:TRUE];

    if (estateData)
    {
        NSUInteger index = [[DataSourceFactory getDataSource] indexOfObject:estateData];
        [estateData setAttributeValues:_tableData];
        [estateData setName:_nameTextField.text];
        [[DataSourceFactory getDataSource] replaceObjectAtIndex:index withObject:estateData];
    }
    else
    {
        NSDate* date = [NSDate date];
        NSString* estateId = [NSString stringWithFormat:@"%@", date];

        EstateData* data = [[EstateData alloc] initWithId:estateId withName:_nameTextField.text withContent:nil withAttributeValues:_tableData withLastUpdate:[NSDate date] withHistory:nil withDeleted:false];
        [[DataSourceFactory getDataSource] addObject:data];
    }
    [self dismissViewControllerAnimated:TRUE completion:^(void){}];
}

- (IBAction)backButtonTouched:(id)sender
{
//    [self dismissAnyKeyboard:self.view];
    [[self view] endEditing:TRUE];

    [self dismissViewControllerAnimated:TRUE completion:^(void){}];
}

- (IBAction)addLineButtonTouched:(id)sender
{
    NSDate* date = [NSDate date];
    NSString* attrId = [NSString stringWithFormat:@"%@", date];
    AttributeData* newAttributeData = [[AttributeData alloc] initWithId:attrId name:@"Account Name" value:@""];

    [_tableData addObject:newAttributeData];
    [_tableView reloadData];
}

- (IBAction)deleteButtonTouched:(id)sender
{
    if (estateData != nil)
    {
        [[DataSourceFactory getDataSource] removeObject:estateData];
    }
    [self dismissViewControllerAnimated:TRUE completion:^(void){}];
}

- (IBAction)tableCellTouched:(id)sender
{
    [[self view] endEditing:TRUE];
}

#pragma mark business logic

- (void)setEstateData:(EstateData*)data
{
    [super setEstateData:data];
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return YES;
}

@end
