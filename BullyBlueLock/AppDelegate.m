//
//  AppDelegate.m
//  BullyBlueLock
//
//  Created by CTOstudent on 2/22/14.
//  Copyright (c) 2014 ECEBullyBlueLock. All rights reserved.
//

#import "AppDelegate.h"
#import "Tab1Controller.h"
#import "Tab2Controller.h"
#import "Tab3Controller.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    NSMutableArray *tabBarViewControllers = [[NSMutableArray alloc] init]; //create and array
    
    
    Tab1Controller *tab1Controller = [[Tab1Controller alloc] init]; //create the tab controller
    UINavigationController *navTab1Controller = [[UINavigationController alloc] init]; //create the navigation controller
    [navTab1Controller setTitle:@"Home"];
    [navTab1Controller addChildViewController:tab1Controller];//This navigation controller controls the tabs
    
    Tab2Controller *tab2Controller = [[Tab2Controller alloc] init];
    UINavigationController *navTab2Controller = [[UINavigationController alloc] init]; //create the navigation controller
    [navTab2Controller setTitle:@"Lock"];
    [navTab2Controller addChildViewController:tab2Controller];//This navigation controller controls the tabs
    
    Tab3Controller *tab3Controller = [[Tab3Controller alloc] init];
    UINavigationController *navTab3Controller = [[UINavigationController alloc] init]; //create the navigation controller
    [navTab3Controller setTitle:@"Settings"];
    [navTab3Controller addChildViewController:tab3Controller];//This navigation controller controls the tabs
    
//    Tab4Controller *tab4Controller = [[Tab4Controller alloc] init];
//    UINavigationController *navTab4Controller = [[UINavigationController alloc] init]; //create the navigation controller
//    [navTab4Controller setTitle:@""];
//    [navTab4Controller addChildViewController:tab4Controller];//This navigation controller controls the tabs
    
    
    [tabBarViewControllers addObject:navTab1Controller];
    [tabBarViewControllers addObject:navTab2Controller];
    [tabBarViewControllers addObject:navTab3Controller];
    //[tabBarViewControllers addObject:navTab4Controller];
    
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:tabBarViewControllers];
    [[self window] setRootViewController:tabBarController];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    NSLog(@"BlueLockAppDelegate applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"BlueLockAppDelegate applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    NSLog(@"BlueLockAppDelegate applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"BlueLockAppDelegate applicationDidBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    NSLog(@"BlueLockAppDelegate applicationWillTerminate");
}

@end
