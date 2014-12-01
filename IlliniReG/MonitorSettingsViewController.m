//
//  MonitorSettingsViewController.m
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 12/1/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import "MonitorSettingsViewController.h"

@interface MonitorSettingsViewController () {
    UISwitch *monitorSwitch;
}

@end

@implementation MonitorSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // load settings
    [self retrieveMonitorSettings];
    
    // Monitor Switch
    monitorSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    monitorSwitch.on = _monitor.status == ON;
    [monitorSwitch addTarget:self action:@selector(monitorSwitchChangeState:) forControlEvents:UIControlEventValueChanged];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.text = _monitor.name;
            cell.accessoryView = monitorSwitch;
        }];
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// dummy values for testing
- (void)retrieveMonitorSettings {
    if (_monitor == nil) {
        _monitor = [[IRMonitor alloc] init];
    }
    _monitor.status = ON;
    _monitor.name = @"TEST Monitor";
}

- (void)monitorSwitchChangeState:(UISwitch *)sender {
    
}


@end
