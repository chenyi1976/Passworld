//
//  Observable.h
//  DigitalEstate
//
//  Created by Yi Chen on 23/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Observer.h"

@interface Observable: NSObject

- (void)registerObserver:(id<Observer>)observer;
- (void)deregisterObserver:(id<Observer>)observer;

- (void)fireDataChanged;

@end
