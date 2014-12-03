//
//  MonitorSettingsViewController.h
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 12/1/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JMStaticContentTableViewController/JMStaticContentTableViewController.h>
#import "IRMonitor.h"

@interface MonitorSettingsViewController : JMStaticContentTableViewController

@property (nonatomic, strong) IRMonitor *monitor;

- (id)initWithMonitor:(IRMonitor *)monitor;

@end
