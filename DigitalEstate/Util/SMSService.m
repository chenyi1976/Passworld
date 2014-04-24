//
//  SMSService.m
//  DigitalEstate
//
//  Created by Yi Chen on 24/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "SMSService.h"

@implementation SMSService

+(void)requestCodeVerficationForPhone:(NSString*)phoneNumber
{
    NSLog(@"requestCodeVerficationForPhone");
};


+(bool)verifyCode:(NSString*)code ForPhone:(NSString*)phoneNumber
{
    NSLog(@"verifyCode");
    return TRUE;
};

@end
