//
//  AppDelegate.h
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/17/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (BOOL)application: (UIApplication *)application openURL: (NSURL *)url sourceApplication: (NSString *)sourceApplication annotation:(id)annotation;

@end

