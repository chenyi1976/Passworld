//
//  AccountTableViewCell.m
//  DigitalEstate
//
//  Created by Yi Chen on 14/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "AccountTableViewCell.h"

@implementation AccountTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
