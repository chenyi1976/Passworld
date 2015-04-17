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
@property EstateData* estateData;

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
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if (_estateData)
    {
        [_nameTextField setText:_estateData.name];
        _tableData = [[NSMutableArray alloc] initWithArray:_estateData.attributeValues copyItems:TRUE];

        [_nameTextField setEnabled:FALSE];
        [_okButton setTitle:NSLocalizedString(@"Edit", @"")];
        [_tableView setEditing:FALSE animated:FALSE];
    }
    else
    {
        [_nameTextField setText:@""];
        AttributeData* accountNameData = [[AttributeData alloc] initWithId:kAttributeAccountName name:@"Username" value:@""];
        AttributeData* accountValueData = [[AttributeData alloc] initWithId:kAttributeAccountValue name:@"Password" value:@""];
        _tableData = [NSMutableArray arrayWithObjects:accountNameData, accountValueData, nil];
        
        [_nameTextField setEnabled:TRUE];
        [_okButton setTitle:NSLocalizedString(@"Save", @"")];
        [_tableView setEditing:TRUE animated:FALSE];
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return FALSE;
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_tableView isEditing])
        return [_tableData count] + 1;
    
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
    
    if (indexPath.row < _tableData.count)
    {
        AttributeData* data = [_tableData objectAtIndex:indexPath.row];
        if (data)
        {
            [result configureAttributeData:data];
        }
    }
    
    return result;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.row < _tableData.count)
        {
            [_tableData removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleNone) {
        AttributeData* data;
        if (indexPath.row < _tableData.count)
        {
            data = [_tableData objectAtIndex:indexPath.row];
        }
        else
        {
            NSDate* date = [NSDate date];
            NSString* attrId = [NSString stringWithFormat:@"%@", date];
            
            data = [[AttributeData alloc] init];
            data.attrId = attrId;
            
            [_tableData addObject:data];
        }

        AccountTableViewCell* cell = (AccountTableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
        
        data.attrName = cell.nameTextField.text;
        data.attrValue = cell.valueTextField.text;
        
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
    NSString* okButtonTitle = [_okButton title];
    if ([okButtonTitle isEqualToString:NSLocalizedString(@"Save", @"")])
    {
        [_nameTextField setEnabled:TRUE];

        [_okButton setTitle:NSLocalizedString(@"Save", @"")];
        [_tableView setEditing:TRUE animated:FALSE];
    }
    else
    {
        [[self view] endEditing:TRUE];
        
        if (_estateData)
        {
            NSUInteger index = [[DataSourceFactory getDataSource] indexOfObject:_estateData];
            [_estateData setAttributeValues:_tableData];
            [_estateData setName:_nameTextField.text];
            [[DataSourceFactory getDataSource] replaceObjectAtIndex:index withObject:_estateData];
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
    [_tableView reloadData];
}

- (IBAction)backButtonTouched:(id)sender
{
//    [self dismissAnyKeyboard:self.view];
    [[self view] endEditing:TRUE];

    [self dismissViewControllerAnimated:TRUE completion:^(void){}];
}

- (IBAction)deleteButtonTouched:(id)sender
{
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Delete current entry？", @"")
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                       destructiveButtonTitle:NSLocalizedString(@"OK", @"")
                                            otherButtonTitles: nil];
    [sheet showInView:self.view];

}

- (IBAction)tableCellTouched:(id)sender
{
    [[self view] endEditing:TRUE];
}

#pragma mark business logic

- (void)updateEstateData:(EstateData*)data
{
    _estateData = data;
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return YES;
}

#pragma mark UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        if (_estateData != nil)
        {
            [[DataSourceFactory getDataSource] removeObject:_estateData];
        }
        [self dismissViewControllerAnimated:TRUE completion:^(void){}];
    }
}

@end
