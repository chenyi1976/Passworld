//
//  DataStrategy.h
//  DigitalEstate
//
//  Created by Yi Chen on 25/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EstateData.h"

@protocol DataStrategy <NSObject>

- (NSArray*)loadEstateData;
- (void)saveEstateData:(NSArray*)estateDatas withDeletedData:(NSArray*)deletedEstateDatas;
- (bool)isLocal;

@end
