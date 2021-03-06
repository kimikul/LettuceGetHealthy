//
//  AppDelegate.m
//  LettuceGetHealthy
//
//  Created by Kimberly Hsiao on 8/29/15.
//  Copyright (c) 2015 hsiao. All rights reserved.
//

#import "LTAppDelegate.h"
#import "LTTabBarController.h"
#import "LTSignUpViewController.h"

@interface LTAppDelegate ()

@end

@implementation LTAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initializeParse];
    [self setupAppearance];
    [self transitionToCorrectViewController];
    
    return YES;
}

- (void)initializeParse {
    [Parse setApplicationId:@"8B3NCaLurRYAEU9uNOEfVDdQNjCfKePknp5fQpbo"
                  clientKey:@"Pr5Htaq0xDhpug69BV5orNpA9Fpky2w6NFpN1zJu"];
}

- (void)setupAppearance {
    [[UITabBar appearance] setTintColor:[UIColor lettuceGreen]];
    [[UITabBar appearance] setBarTintColor:[UIColor darkGrayColor]];
}

- (void)transitionToCorrectViewController {
    UIViewController *vc;
    UIStoryboard *mainStoryboard = [UIStoryboard mainStoryboard];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *currentUser = [defaults objectForKey:LTCurrentUserDefaultsKey];
    if (currentUser) {
        vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"LTTabBarController"];
    } else {
        vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"LTSignUpViewController"];
    }
    
    [self setRootViewController:vc];
}

- (void)setRootViewController:(UIViewController*)vc {
    [UIView transitionWithView:self.window.rootViewController.view duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.window.rootViewController = vc;
                    } completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
