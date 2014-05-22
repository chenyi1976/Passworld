//
//  DetailViewController.h
//  DigitalEstate
//
//  Created by Yi Chen on 15/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EstateData.h"

@interface DetailViewController : UIViewController
{
    @protected
    EstateData* estateData;
}

- (void)setEstateData:(EstateData*)estateData;

@end
