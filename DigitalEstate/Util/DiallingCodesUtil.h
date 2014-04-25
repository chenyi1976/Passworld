//
//  HMLocationManager.h
//
//  Created by Hesham Abd-Elmegid on 26/11/12.
//  Copyright (c) 2012 Hesham Abd-Elmegid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface DiallingCodesUtil : NSObject <CLLocationManagerDelegate>

+(DiallingCodesUtil*)sharedInstance;

- (NSArray*)getCountryCodes;
- (NSArray*)getCountryNames;

- (NSArray*)getMostPopularCountryCodes;
- (NSArray*)getMostPopularCountryNames;

- (NSString*)getCountryCodeForName:(NSString*)name;
- (NSString*)getCountryNameForCode:(NSString*)code;

- (NSString*)getDiallingCodeForCountryCode:(NSString *)countryCode;
- (NSArray*)getCountryCodesWithDiallingCode:(NSString *)diallingCode;

- (NSString*)getDiallingCodeForCountryName:(NSString *)countryName;
- (NSArray*)getCountryNamesWithDiallingCode:(NSString *)diallingCode;

@end
