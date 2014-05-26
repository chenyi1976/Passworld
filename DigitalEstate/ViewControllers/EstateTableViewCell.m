//
//  EstateTableViewCell.m
//  DigitalEstate
//
//  Created by Yi Chen on 22/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "EstateTableViewCell.h"
#import "AttributeData.h"

@implementation EstateTableViewCell

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

#pragma mark business method

- (void)configureForEstateData:(EstateData*)data
{
    if (data == nil)
        return;
    
    if (data.name == nil || [data.name length] == 0)
    {
        if ([data.attributeValues count] > 0)
        {
            _nameLabel.text = @"Account";
        }
        else
        {
            _nameLabel.text = @"Note";
        }
    }
    else
    {
        _nameLabel.text = data.name;
    }
    if (data.content == nil || [data.content length] == 0)
    {
        if ([data.attributeValues count] > 0)
        {
            _contentLabel.numberOfLines = [data.attributeValues count] * 2;
            
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
            UIFont* smallFont = [UIFont systemFontOfSize:12.f];
            UIColor* lightBlueColor = [UIColor colorWithRed:0x22/255.0f green:0x22/255.0f blue:0x99/255.0f alpha:1];
            
            bool isFirst = TRUE;
            
            for (AttributeData* attributeData in data.attributeValues)
            {
                if (!isFirst)
                {
                    [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
                }
                isFirst = FALSE;
                NSString * attrName = attributeData.attrName;
                if (attrName.length > 23)
                {
                    attrName = [NSString stringWithFormat:@"%@...", [attrName substringToIndex:20]];
                }
                NSAttributedString* attrNameStr = [[NSAttributedString alloc] initWithString:attrName attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:smallFont}];
                [attributedText appendAttributedString:attrNameStr];
                
                [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
                
                NSString * attrValue = attributeData.attrValue;
                if (attrValue.length > 23)
                {
                    attrValue = [NSString stringWithFormat:@"%@...", [attrValue substringToIndex:20]];
                }
                NSAttributedString* attrValueStr = [[NSAttributedString alloc] initWithString:attributeData.attrValue attributes:@{NSForegroundColorAttributeName:lightBlueColor}];
                [attributedText appendAttributedString:attrValueStr];
            }
            _contentLabel.attributedText = attributedText;
        }
        else
        {
            _contentLabel.numberOfLines = 1;
            _contentLabel.text =  @"";
        }
    }
    else
    {
        NSUInteger lineCount = data.content.length / 22 + 1;
        _contentLabel.numberOfLines = lineCount > 4? 4 : lineCount;
        _contentLabel.text =  data.content;
    }
    [_iconView setImage: [data.attributeValues count] == 0 ? [UIImage imageNamed:@"circle_text.png"]: [UIImage imageNamed:@"password.png"] ];
   
}



@end
