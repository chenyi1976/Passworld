//
//  HMLocationManager.m
//
//  Created by Hesham Abd-Elmegid on 26/11/12.
//  Copyright (c) 2012 Hesham Abd-Elmegid. All rights reserved.
//

#import "DiallingCodesUtil.h"

@interface DiallingCodesUtil ()

@property (nonatomic, strong) NSDictionary *diallingCodesDictionary;

@end

@implementation DiallingCodesUtil

static DiallingCodesUtil* instance = nil;

+(DiallingCodesUtil*)sharedInstance
{
    if (!instance)
        instance = [[DiallingCodesUtil alloc] init];
    return instance;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"DiallingCodes" ofType:@"plist"];
        self.diallingCodesDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    }
    return self;
}

#pragma mark - interface implementation

NSArray* countryNames = nil;
NSArray* countryCodes = nil;
NSDictionary* countryNameCodeDict = nil;

-(void)initCountryInformation
{
    NSLocale *locale = [NSLocale currentLocale];
    NSArray *countryArray = [_diallingCodesDictionary allKeys];//[NSLocale ISOCountryCodes];
    
    NSMutableArray *sortedCountryArray = [[NSMutableArray alloc] init];
    NSMutableDictionary* countryDict = [[NSMutableDictionary alloc] init];
    
    for (NSString *countryCode in countryArray) {
        NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];

        if (!displayNameString)
        {
            NSLog(@"can not find country for code: %@", countryCode);
            continue;
        }
        [sortedCountryArray addObject:displayNameString];
        [countryDict setObject:countryCode forKey:displayNameString];
    }
    
    [sortedCountryArray sortUsingSelector:@selector(localizedCompare:)];
    countryNames = [NSArray arrayWithArray:sortedCountryArray];
    NSMutableArray* countryCodeArray = [[NSMutableArray alloc] init];
    for (NSString* countryName in countryNames)
    {
        [countryCodeArray addObject:[countryDict objectForKey:countryName]];
    }
    countryCodes = [NSArray arrayWithArray:countryCodeArray];
    countryNameCodeDict = [NSDictionary dictionaryWithDictionary:countryDict];
}

- (NSArray*)getCountryCodes
{
    if (!countryCodes)
    {
        [self initCountryInformation];
    }
    return countryCodes;
}

- (NSArray*)getCountryNames
{
    if (!countryNames)
    {
        [self initCountryInformation];
    }
    return countryNames;
}

NSArray* popularCountryNames = nil;
NSArray* popularCountryCodes = nil;

- (NSArray*)getMostPopularCountryCodes
{
    if (!popularCountryCodes)
    {
        popularCountryCodes = [NSArray arrayWithObjects:@"au", @"cn", @"uk", @"us", nil];
    }
    return popularCountryCodes;
}

- (NSArray*)getMostPopularCountryNames
{
    if (!popularCountryNames)
    {
        popularCountryNames = [NSArray arrayWithObjects:@"Australia", @"China", @"United Kingdom", @"United States", nil];
    }
    return popularCountryNames;
}


- (NSString*)getCountryCodeForName:(NSString*)name
{
    if (!countryNameCodeDict)
    {
        [self initCountryInformation];
    }
    return [countryNameCodeDict objectForKey:name];
}

- (NSString*)getCountryNameForCode:(NSString*)code
{
    if (!countryNameCodeDict)
    {
        [self initCountryInformation];
    }
    NSArray* names = [countryNameCodeDict allKeysForObject:code];
    if (names == nil)
        return nil;
    if (names.count == 0)
        return nil;
    return [names objectAtIndex:0];
}


- (NSString*)getDiallingCodeForCountryCode:(NSString *)countryCode
{
    if (!countryCode)
        return nil;
    return [self.diallingCodesDictionary objectForKey:[countryCode lowercaseString]];
}

- (NSArray*)getCountryCodesWithDiallingCode:(NSString *)diallingCode {
    if (!diallingCode)
        return nil;

    if ([diallingCode hasPrefix:@"+"]) {
        diallingCode = [diallingCode substringFromIndex:1];
    }
    
    NSMutableArray *countriesArray = [[NSMutableArray alloc] init];
    [self.diallingCodesDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isEqual:diallingCode])
            [countriesArray addObject:key];
    }];
    
    return countriesArray;
}

- (NSString*)getDiallingCodeForCountryName:(NSString *)countryName
{
    NSString* countryCode = [self getCountryCodeForName:countryName];
    return [self getDiallingCodeForCountryCode:countryCode];
}

- (NSArray*)getCountryNamesWithDiallingCode:(NSString *)diallingCode
{
    if (!diallingCode)
        return nil;
    
    if ([diallingCode hasPrefix:@"+"]) {
        diallingCode = [diallingCode substringFromIndex:1];
    }
    
    NSMutableArray *countriesArray = [[NSMutableArray alloc] init];
    [self.diallingCodesDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isEqual:diallingCode])
        {
            NSString* countryName = [self getCountryNameForCode:key];
            [countriesArray addObject:countryName];
        }
    }];
    
    return countriesArray;
}


@end
