//
//  ObservableDataSource.m
//  DigitalEstate
//
//  Created by Yi Chen on 23/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "Observable.h"

@implementation Observable

NSMutableArray* observers = nil;

- (id) init
{
    if (self = [super init])
    {
        observers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)registerObserver:(id<Observer>)observer
{
    [observers addObject:observer];
}

- (void)deregisterObserver:(id<Observer>)observer
{
    [observers removeObject:observer];
}

- (void)fireDataChanged
{
    for (id<Observer> observer in observers)
    {
        [observer dataChanged];
    }
}

@end
