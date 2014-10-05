//
//  AppDelegate.m
//  CBStoreHouseTransition
//
//  Created by coolbeet on 10/2/14.
//  Copyright (c) 2014 Suyu Zhang. All rights reserved.
//

#import "AppDelegate.h"
#import "ContentViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor blackColor];
    ContentViewController *contentViewController = [[ContentViewController alloc] initWithTitle:@"Explore" contentImage:[UIImage imageNamed:@"discover"] showBackButton:NO];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:contentViewController];
    [navigationController setNavigationBarHidden:YES];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
