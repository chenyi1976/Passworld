//
//  AccountTableViewCell.m
//  DigitalEstate
//
//  Created by Yi Chen on 14/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "AccountTableViewCell.h"
#import "AccountViewController.h"
#import "ViewUtil.h"

@implementation AccountTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];

//    [_nameTextField setEnabled:editing];
//    [_valueTextField setEnabled:editing];
    if (!editing)
    {
        [_nameTextField resignFirstResponder];
        [_valueTextField resignFirstResponder];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn");
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidEndEditing");
    [self endEditing:TRUE];
    [textField resignFirstResponder];

    if (_nameTextField == textField || _valueTextField == textField)
    {
        UITableView* tableView = (UITableView*)self.superview.superview;
        [tableView endEditing:TRUE];
        AccountViewController* controller = (AccountViewController*)tableView.dataSource;
        NSIndexPath* indexPath = [controller.tableView indexPathForCell:self];
        [controller tableView:controller.tableView commitEditingStyle:UITableViewCellEditingStyleNone forRowAtIndexPath:indexPath];
    }
}

//- (void) textFieldDidBeginEditing:(UITextField *)textField {
//    NSLog(@"textFieldDidBeginEditing");
//    
//    
//    
//}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    NSLog(@"valueFieldTouched");
    if (![self isEditing])
    {
        UITableView* tableView = (UITableView*)self.superview.superview;
        AccountViewController* controller = (AccountViewController*)tableView.dataSource;
        [ViewUtil popupMessage:@"Value Copied!" forView:controller.view];
        
        [UIPasteboard generalPasteboard].string = [textField text];
    }
    
    return [self isEditing];
}


#pragma mark - IBAction

- (IBAction)deleteButtonClicked:(id)sender
{
    UITableView* tableView = (UITableView*)self.superview.superview;
    AccountViewController* controller = (AccountViewController*)tableView.dataSource;
    NSIndexPath* indexPath = [controller.tableView indexPathForCell:self];
    [controller tableView:controller.tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
}

- (IBAction)valueFieldTouched:(id)sender {
    NSLog(@"valueFieldTouched");
}

- (void)configureAttributeData:(AttributeData*)data
{
    if (data)
    {
        _nameTextField.text = data.attrName;
        _valueTextField.text = data.attrValue;
    }
}


@end
