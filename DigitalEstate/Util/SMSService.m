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

    return;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"http://digitalestate.sinaapp.com/sms/api/sendVerify"];
//    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/digitalestate/sms/api/sendVerify"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    NSString * params = [NSString stringWithFormat:@"mobileNo=%@", phoneNumber];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data)
        {
            NSString* serverCode = [NSString stringWithUTF8String:[data bytes]];
            NSLog(@"return result: %@", serverCode);
//            if (![serverCode isEqualToString:code])
//            {
//                error = [NSError errorWithDomain:@"SMSService" code:1 userInfo:nil];
//            }
        }
        if (error)
        {
            NSLog(@"Error: %@", error);
        }
    }];
    
    [postDataTask resume];
};


+(void)verifyCode:(NSString*)code ForPhone:(NSString*)phoneNumber completionHandler:(void (^)(NSError* error)) handler
{
    NSLog(@"verifyCode");
    
    handler(nil);

    return;

    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"http://digitalestate.sinaapp.com/sms/api/getCode"];
//    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/digitalestate/sms/api/getCode"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    NSString * params = [NSString stringWithFormat:@"mobileNo=%@", phoneNumber];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data)
        {
            NSString* serverCode = [NSString stringWithUTF8String:[data bytes]];
            if (![serverCode isEqualToString:code])
            {
                error = [NSError errorWithDomain:@"SMSService" code:1 userInfo:nil];
            }
        }
//        NSLog(@"post request finished, data: %@", data);
        if (error)
        {
            NSLog(@"Error: %@", error);
        }
        if (handler)
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                handler(error);
            });
        }
    }];
    
    [postDataTask resume];
};

@end
