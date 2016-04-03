//
//  AccountTableViewCell.m
//  DigitalEstate
//
//  Created by Yi Chen on 14/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "AccountTableViewCell.h"
#import "DetailViewController.h"

@implementation AccountTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[self contentView].layer setBorderWidth:3.0f];
        [[self contentView].layer setBorderColor:[UIColor whiteColor].CGColor];
    }
    return self;
}

- (void)awakeFromNib
{
    [[self contentView].layer setBorderWidth:3.0f];
    [[self contentView].layer setBorderColor:[UIColor whiteColor].CGColor];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];

    if (!editing)
    {
        [_nameTextField resignFirstResponder];
        [_valueTextField resignFirstResponder];
        [self setBackgroundColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1]];
    }
    else
    {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - IBAction

- (IBAction)deleteButtonClicked:(id)sender
{
    UITableView* tableView = (UITableView*)self.superview.superview;
    DetailViewController* controller = (DetailViewController*)tableView.dataSource;
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
