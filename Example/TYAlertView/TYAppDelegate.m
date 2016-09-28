//
//  TYAppDelegate.m
//  TYAlertView
//
//  Created by luckytianyiyan on 09/19/2016.
//  Copyright (c) 2016 luckytianyiyan. All rights reserved.
//

#import "TYAppDelegate.h"
#import "TYViewController.h"
#import <TYAlertView.h>

@implementation TYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    _window.rootViewController = [[TYViewController alloc] init];
    [_window makeKeyAndVisible];
    
    // Appearance
//    [TYAlertView appearance].titleColor = [UIColor redColor];
//    [TYAlertView appearance].messageColor = [UIColor yellowColor];
    return YES;
}

@end
