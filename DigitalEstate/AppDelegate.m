//
//  AppDelegate.m
//  DigitalEstate
//
//  Created by Yi Chen on 15/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "AppDelegate.h"
#import "ConstantDefinition.h"
//#import <DropboxSDK/DropboxSDK.h>
#import "DataSourceFactory.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    DBSession *dbSession = [[DBSession alloc]
//                            initWithAppKey:@"ctbo82zuxohb4qu"
//                            appSecret:@"krbzzn155l7htre"
//                            root:kDBRootAppFolder]; // either kDBRootAppFolder or kDBRootDropbox
//    [DBSession setSharedSession:dbSession];
//    DBAccountManager *accountManager = [[DBAccountManager alloc] initWithAppKey:@"ctbo82zuxohb4qu" secret:@"krbzzn155l7htre"];
//    [DBAccountManager setSharedManager:accountManager];

    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
//    NSTimeInterval deactiveTime = [[NSDate date] timeIntervalSince1970];
//    
//    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
//    [prefs setDouble:deactiveTime forKey:kDeactiveTime];
//    [prefs synchronize];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
//    
//    NSInteger pinThreshold = [prefs integerForKey:kPinThreshold];
//    double deactiveTime =  [prefs doubleForKey:kDeactiveTime];
//    NSTimeInterval activeTime = [[NSDate date] timeIntervalSince1970];
//    
//    if (activeTime - deactiveTime > pinThreshold)
//    {
//        long pass1 = [prefs integerForKey:kPassword1];
//        long pass2 = [prefs integerForKey:kPassword2];
//        long pass3 = [prefs integerForKey:kPassword3];
//        long pass4 = [prefs integerForKey:kPassword4];
//        if (pass1 != 0 || pass2 != 0 || pass3 != 0 || pass4 != 0)
//        {
//            UIViewController* rootViewController = [[self window] rootViewController];
//            UIViewController *screen = [rootViewController.storyboard instantiateViewControllerWithIdentifier:@"SecurityPassViewController"];
//            
//            
////            [UIView ]
////            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            
////            [app.window setRootViewController:screen];
//        }
//    }

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url sourceApplication:(NSString *)source annotation:(id)annotation {
    
//    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
//    if (![prefs boolForKey:kIsLinkingDropbox])
//    {
//        [prefs setBool:true forKey:kIsLinkingDropbox];
//        [prefs synchronize];
//    }
//
//    
//    if ([[DBSession sharedSession] handleOpenURL:url]) {
//        if ([[DBSession sharedSession] isLinked]) {
//            EstateDataSource* datasource = [DataSourceFactory getDataSource];
//            [datasource updateDataStrategy];
//            NSLog(@"App linked successfully!");
//        }
//        return YES;
//    }
    return NO;
}

@end
