//
//  EstateTableViewCell.h
//  DigitalEstate
//
//  Created by Yi Chen on 22/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EstateData.h"

@interface EstateTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *attrContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueContentLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *iconView;

- (void)configureForEstateData:(EstateData*)data;

@end
