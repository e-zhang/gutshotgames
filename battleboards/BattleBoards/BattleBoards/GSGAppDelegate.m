//
//  GSGAppDelegate.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "GSGAppDelegate.h"

#import "MenuView.h"

@implementation GSGAppDelegate


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"YsxxssPAuFqDpFkWvoX4feewJNy2rYTEFBgrFYEz" clientKey:@"q0yBsyHX60yzfFYRqQa9FNzHY5SOnztCCML1G8L1"];
    
    [PFFacebookUtils initializeFacebook];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
        [[PFInstallation currentInstallation] saveInBackground];
    }
    
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[MenuView alloc] initWithNibName:@"MenuView" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    return YES;
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    
    NSLog(@"newDeviceToken-%@",newDeviceToken);
    NSString *oldToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
    }
    
    if (![oldToken isEqualToString:currentInstallation.deviceToken])
    {
        
        [currentInstallation saveEventually:^(BOOL succeeded, NSError *error) {
            
            if (succeeded)
            {
                [[NSUserDefaults standardUserDefaults] setObject:currentInstallation.deviceToken forKey:@"deviceToken"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
