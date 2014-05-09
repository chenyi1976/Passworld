//
//  SMSService.h
//  DigitalEstate
//
//  Created by Yi Chen on 24/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSService : NSObject<NSURLSessionDelegate>

+(void)requestCodeVerficationForPhone:(NSString*)phoneNumber;

+(void)verifyCode:(NSString*)code ForPhone:(NSString*)phoneNumber completionHandler:(void (^)(NSError* error)) handler;

@end
