//
//  Observer.h
//  DigitalEstate
//
//  Created by Yi Chen on 23/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Observer <NSObject>

- (void)dataChanged;

@end
