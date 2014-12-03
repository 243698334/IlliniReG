//
//  MonitorSettingsViewController.m
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 12/1/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import "MonitorSettingsViewController.h"

@interface MonitorSettingsViewController ()

@property (nonatomic, strong) UISwitch *monitorSwitch;
@property (nonatomic, strong) UISwitch *autoRegisterSwitch;
@property (nonatomic, strong) UISwitch *pushNotificationSwitch;

@end

@implementation MonitorSettingsViewController

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Prevent retain cycle
    __unsafe_unretained __block MonitorSettingsViewController *safeSelf = self;
    
    // Load settings
    [self retrieveMonitorSettings];
    
    // Title
    self.title = _monitor.name;
    
    // Monitor switch
    _monitorSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    _monitorSwitch.on = _monitor.status == ON;
    [_monitorSwitch addTarget:self action:@selector(monitorSwitchChangeState:) forControlEvents:UIControlEventValueChanged];
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"MonitorSwitchCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = safeSelf.monitor.name;
            cell.accessoryView = safeSelf.monitorSwitch;
        }];
    }];
    
    // Auto register
    _autoRegisterSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    _autoRegisterSwitch.on = _monitor.autoRegister;
    [_autoRegisterSwitch addTarget:self action:@selector(autoRegisterSwitchChangeState:) forControlEvents:UIControlEventValueChanged];
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"AutoRegisterSwitchCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"Auto Register";
            cell.accessoryView = safeSelf.autoRegisterSwitch;
        }];
        section.footerTitle = @"Activate Auto Register requires Premium account. Please refer to Profile page and upgrade your account for only $1.99.";
    }];

    // Section list
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.headerTitle = @"Section List";
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"SectionListAddSectionCell";
            cell.textLabel.text = @"Add Section...";
        } whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }];
        section.footerTitle = @"Auto Register will not be available until ALL of the sections in the list are open.";
    }];
    
    // Fake browser setting
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.headerTitle = @"Browser";
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = @"BrowserRefreshFrequencyCell";
            cell.textLabel.text = @"Refresh Frequency";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%zd sec", safeSelf.monitor.refreshFrequency];
        } whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.tableView deselectRowAtIndexPath:indexPath animated:YES];
            //
        }];
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = @"BrowserUserAgentCell";
            cell.textLabel.text = @"User Agent";
            cell.detailTextLabel.text = safeSelf.monitor.userAgentType;
        } whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.tableView deselectRowAtIndexPath:indexPath animated:YES];
            //
        }];
        section.footerTitle = @"Higher frequency might increase the chance of being flagged by the UIUC Enterprise System.";
    }];
    
    // Notification
    _pushNotificationSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    _pushNotificationSwitch.on = _monitor.pushNotification;
    [_pushNotificationSwitch addTarget:self action:@selector(pushNotificationSwitchChangeState:) forControlEvents:UIControlEventValueChanged];
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.headerTitle = @"Notifications";
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"NotificationPushCell";
            cell.textLabel.text = @"Push Notification";
            cell.accessoryView = safeSelf.pushNotificationSwitch;
        } whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.tableView deselectRowAtIndexPath:indexPath animated:YES];
            //
        }];
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = @"NotificationSMSCell";
            cell.textLabel.text = @"SMS";
            cell.detailTextLabel.text = safeSelf.monitor.smsNumber == nil ? @"None" : safeSelf.monitor.smsNumber;
        } whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.tableView deselectRowAtIndexPath:indexPath animated:YES];
            //
        }];
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = @"NotificationEmailCell";
            cell.textLabel.text = @"Email";
            cell.detailTextLabel.text = safeSelf.monitor.email == nil ? @"None" : safeSelf.monitor.email;
        } whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.tableView deselectRowAtIndexPath:indexPath animated:YES];
            //
        }];
        section.footerTitle = @"Notifications might expect latency no matter which method is chosen.";
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
    _monitor.name = @"Test Monitor";
    _monitor.autoRegister = NO;
    _monitor.refreshFrequency = 30;
    _monitor.userAgentType = @"Chrome";
    _monitor.pushNotification = YES;
    _monitor.smsNumber = @"(217) 419-5313";
    _monitor.email = nil;
    
}

- (void)monitorSwitchChangeState:(UISwitch *)sender {
    _monitor.status = sender.on ? ON : OFF;
}

- (void)autoRegisterSwitchChangeState:(UISwitch *)sender {
    _monitor.autoRegister = sender.on;
}

- (void)pushNotificationSwitchChangeState:(UISwitch *)sender {
    _monitor.pushNotification = sender.on;
}


@end
