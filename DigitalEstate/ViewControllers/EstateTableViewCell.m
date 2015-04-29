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
        _nameLabel.text = @"Account";
    }
    else
    {
        _nameLabel.text = data.name;
    }
    if (data.content == nil || [data.content length] == 0)
    {
        if ([data.attributeValues count] > 0)
        {
            _attrContentLabel.numberOfLines = [data.attributeValues count];
            _valueContentLabel.numberOfLines = [data.attributeValues count];
            
            NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] init];
            NSMutableAttributedString *valueText = [[NSMutableAttributedString alloc] init];
            UIFont* attrNameFont = [UIFont systemFontOfSize:13.0];
            UIFont* attrValueFont = [UIFont systemFontOfSize:17.0];
            UIColor* lightBlueColor = [UIColor colorWithRed:0x33/255.0f green:0x66/255.0f blue:0xFF/255.0f alpha:1];

            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.minimumLineHeight = 25.f;
            paragraphStyle.maximumLineHeight = 25.f;
            
            bool isFirst = TRUE;
            
            for (AttributeData* attributeData in data.attributeValues)
            {
                if (!isFirst)
                {
                    [attrText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
                    [valueText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
                }
                isFirst = FALSE;
                NSString * attrName = attributeData.attrName;
                if (attrName == nil)
                {
                    attrName = @"";
                }
                
                if (attrName.length > 15)
                {
                    attrName = [NSString stringWithFormat:@"%@... ", [attrName substringToIndex:12]];
                }
                else{
                    attrName = [attrName stringByPaddingToLength:16 withString:@" " startingAtIndex:0];
                }
                
                NSAttributedString* attrNameStr = [[NSAttributedString alloc] initWithString:attrName attributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:attrNameFont, NSBaselineOffsetAttributeName : [NSNumber numberWithFloat:1.5], NSParagraphStyleAttributeName : paragraphStyle}];
                
                [attrText appendAttributedString:attrNameStr];
                
                NSString * attrValue = attributeData.attrValue;
                if (attrValue == nil)
                {
                    attrValue = @"";
                }
                
                if (attrValue.length > 18)
                {
                    attrValue = [NSString stringWithFormat:@"%@... ", [attrValue substringToIndex:15]];
                }
                else{
                    attrValue = [attrValue stringByPaddingToLength:19 withString:@" " startingAtIndex:0];
                }

                NSAttributedString* attrValueStr = [[NSAttributedString alloc] initWithString:attrValue attributes:@{NSForegroundColorAttributeName:lightBlueColor, NSFontAttributeName:attrValueFont, NSParagraphStyleAttributeName : paragraphStyle}];
                
                [valueText appendAttributedString:attrValueStr];

            }
            _attrContentLabel.attributedText = attrText;
            _valueContentLabel.attributedText = valueText;
        }
        else
        {
            _attrContentLabel.numberOfLines = 1;
            _attrContentLabel.text =  @"";
        }
    }
    else
    {
        NSUInteger lineCount = data.content.length / 22 + 1;
        _attrContentLabel.numberOfLines = lineCount > 4? 4 : lineCount;
        _attrContentLabel.text =  data.content;
    }
    [_iconView setImage: [data.attributeValues count] == 0 ? [UIImage imageNamed:@"circle_text.png"]: [UIImage imageNamed:@"password.png"] ];
   
}



@end
