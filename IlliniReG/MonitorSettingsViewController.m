//
//  MonitorSettingsViewController.m
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 12/1/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import "MonitorSettingsViewController.h"

@interface MonitorSettingsViewController ()

@property (nonatomic, strong) UIBarButtonItem *doneButtonItem;
@property (nonatomic, strong) UISwitch *monitorSwitch;
@property (nonatomic, strong) UISwitch *autoRegisterSwitch;
@property (nonatomic, strong) UISwitch *pushNotificationSwitch;

@property (nonatomic, readonly) NSUInteger MonitorSwitchSectionIndex;
@property (nonatomic, readonly) NSUInteger AutoRegisterSwitchSectionIndex;
@property (nonatomic, readonly) NSUInteger SectionListSectionIndex;
@property (nonatomic, readonly) NSUInteger BrowserSectionIndex;
@property (nonatomic, readonly) NSUInteger NotificationsSectionIndex;

@end

@implementation MonitorSettingsViewController

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (id)initWithMonitor:(IRMonitor *)monitor {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        _monitor = monitor;
        _isUpdating = _monitor != nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Prevent retain cycle
    __unsafe_unretained __block MonitorSettingsViewController *safeSelf = self;
    
    // Done button (only for new monitors)
    if (_monitor == nil) {
        _doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(addNewMonitor)];
        self.navigationItem.rightBarButtonItem = _doneButtonItem;
    }
    
    // Load settings
    [self retrieveMonitorSettings];
    
    // Title
    self.title = _monitor.name;
    
    // Monitor switch
    _MonitorSwitchSectionIndex = 0;
    _monitorSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [_monitorSwitch setOn:_monitor.status == ON];
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
    _AutoRegisterSwitchSectionIndex = 1;
    _autoRegisterSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [_autoRegisterSwitch setOn:_monitor.autoRegister];
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
    _SectionListSectionIndex = 2;
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
    _BrowserSectionIndex = 3;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.headerTitle = @"Browser";
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = @"BrowserRefreshFrequencyCell";
            cell.textLabel.text = @"Refresh Frequency";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ sec", [safeSelf.monitor.refreshFrequency stringValue]];
        } whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.tableView deselectRowAtIndexPath:indexPath animated:YES];
            UIAlertView *updateBrowserRefreshFrequencyAlertView = [[UIAlertView alloc] initWithTitle:@"Refresh Frequency"
                                                                                             message:@"Please enter the new refresh frequency in seconds."
                                                                                            delegate:safeSelf
                                                                                   cancelButtonTitle:@"Cancel"
                                                                                   otherButtonTitles:@"OK", nil];
            updateBrowserRefreshFrequencyAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [[updateBrowserRefreshFrequencyAlertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
            [[updateBrowserRefreshFrequencyAlertView textFieldAtIndex:0] becomeFirstResponder];
            [updateBrowserRefreshFrequencyAlertView textFieldAtIndex:0].placeholder = [NSString stringWithFormat:@"Current value: %ld sec", (long)[safeSelf.monitor.refreshFrequency integerValue]];
            [updateBrowserRefreshFrequencyAlertView show];
        }];
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = @"BrowserUserAgentCell";
            cell.textLabel.text = @"User Agent";
            cell.detailTextLabel.text = safeSelf.monitor.userAgentType;
        } whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }];
        section.footerTitle = @"Higher frequency might increase the chance of being flagged by the UIUC Enterprise System.";
    }];
    
    // Notification
    _NotificationsSectionIndex = 4;
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
            [safeSelf.tableView deselectRowAtIndexPath:indexPath animated:YES];
            UIAlertView *updateSMSNumberAlertView = [[UIAlertView alloc] initWithTitle:@"Phone Number"
                                                                               message:@"Please enter your cell phone number to receive SMS notification."
                                                                              delegate:safeSelf
                                                                     cancelButtonTitle:@"Cancel"
                                                                     otherButtonTitles:@"OK", nil];
            updateSMSNumberAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [[updateSMSNumberAlertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
            [[updateSMSNumberAlertView textFieldAtIndex:0] becomeFirstResponder];
            [[updateSMSNumberAlertView textFieldAtIndex:0] addTarget:safeSelf action:@selector(formatInputAsPhoneNumber:) forControlEvents:UIControlEventEditingChanged];
            [updateSMSNumberAlertView show];
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadSectionList];
}

- (void)loadSectionList {
    [self.tableView beginUpdates];
    for (NSUInteger i = 0; i < [_monitor.sectionEntries count]; i++) {
//        IRSectionEntry *currentSectionEntry = [_monitor.entries objectAtIndex:i];
//        [self insertCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
//            staticContentCell.reuseIdentifier = @"SectionCell";
//            staticContentCell.cellStyle = UITableViewCellStyleSubtitle;
//            cell.textLabel.text = currentSectionEntry.section;
//            cell.detailTextLabel.text = [NSString stringWithFormat:@"CRN: %@", currentSectionEntry.crn];
//        } atIndexPath:[NSIndexPath indexPathForRow:i inSection:_SectionListSectionIndex] animated:YES];
    }
    [self.tableView endUpdates];
}

- (void)formatInputAsPhoneNumber:(UITextField *)textField {
    NSString *currentInput = textField.text;
    NSString *currentNumericalInput = [[currentInput componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]]componentsJoinedByString:@""];
    NSString *currentFormattedInput = nil;
    if ([currentNumericalInput length] == 0) {
        currentFormattedInput = @"";
    } else if ([currentNumericalInput length] <=3) {
        currentFormattedInput = [NSString stringWithFormat:@"(%@", currentNumericalInput];
    } else if ([currentNumericalInput length] > 3 && [currentNumericalInput length] <= 6) {
        currentFormattedInput = [NSString stringWithFormat:@"(%@) %@", [currentNumericalInput substringWithRange:NSMakeRange(0, 3)], [currentNumericalInput substringFromIndex:3]];
    } else if ([currentNumericalInput length] > 6 && [currentNumericalInput length] <= 10) {
        currentFormattedInput = [NSString stringWithFormat:@"(%@) %@-%@", [currentNumericalInput substringWithRange:NSMakeRange(0, 3)], [currentNumericalInput substringWithRange:NSMakeRange(3, 3)], [currentNumericalInput substringFromIndex:6]];
    } else {
        currentFormattedInput = currentNumericalInput;
    }
    textField.text = currentFormattedInput;
    [textField reloadInputViews];
}

# pragma mark - Alert View

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"Field: %@", [alertView title]);
    NSLog(@"New Value: %@", [alertView textFieldAtIndex:0].text);
    if (buttonIndex == 0) {
        return;
    }
    if (_monitor == nil) {
        _monitor = [[IRMonitor alloc] init];
    }
    if ([[alertView title] isEqualToString:@"Refresh Frequency"]) {
        _monitor.refreshFrequency = [NSNumber numberWithInteger:[[alertView textFieldAtIndex:0].text integerValue]];
        if (_isUpdating) {
            [self updateCurrentMonitor:[NSIndexPath indexPathForRow:0 inSection:_BrowserSectionIndex]];
        }
    } else if ([[alertView title] isEqualToString:@"Phone Number"]) {
        _monitor.smsNumber = [alertView textFieldAtIndex:0].text;
        if (_isUpdating) {
            [self updateCurrentMonitor:[NSIndexPath indexPathForRow:1 inSection:_NotificationsSectionIndex]];
        }
    } else if ([[alertView title] isEqualToString:@"Email Address"]) {
        _monitor.email = [alertView textFieldAtIndex:0].text;
        if (_isUpdating) {
            [self updateCurrentMonitor:[NSIndexPath indexPathForRow:2 inSection:_NotificationsSectionIndex]];
        }
    } else {
        return;
    }
}

# pragma mark - Picker View

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row == 0) {
        return @"Chrome";
    } else if (row == 1) {
        return @"Firefox";
    } else if (row == 2) {
        return @"Safari";
    } else {
        return nil;
    }
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

- (void)addNewMonitor {
    if (_monitor == nil) {
        
    }
    
}

- (void)updateCurrentMonitor:(NSIndexPath *)indexPath {
    [self performSelector:@selector(displayActivityView) withObject:nil afterDelay:0.3];
    AFHTTPRequestOperationManager *updateMonitorManager = [AFHTTPRequestOperationManager manager];
    updateMonitorManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    updateMonitorManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *updateMonitorParameters = @{@"monitorName":_monitor.name,
                                              @"autoRegister":_monitor.autoRegister ? @"YES" : @"NO",
                                              @"refreshFrequency":[_monitor.refreshFrequency stringValue],
                                              @"userAgentType":_monitor.userAgentType,
                                              @"userAgentContent":_monitor.userAgentContent,
                                              @"pushNotification":_monitor.pushNotification ? @"YES" : @"NO",
                                              @"smsNumber":_monitor.smsNumber,
                                              @"email":_monitor.email,
                                              @"monitorStatus": [IRMonitor statusToString:_monitor.status]};
    NSLog(@"Dictionary: %@", [updateMonitorParameters description]);
    NSLog(@"Update with URL: %@", [MonitorAPI stringByAppendingString:[NSString stringWithFormat:@"%@.json", _monitor.monitorID]]);
    [updateMonitorManager PUT:[MonitorAPI stringByAppendingString:[NSString stringWithFormat:@"%@.json", _monitor.monitorID]] parameters:updateMonitorParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.tableView beginUpdates];
        [[self sectionAtIndex:indexPath.section] reloadCellAtIndex:indexPath.row];
        [self.tableView endUpdates];
        [self removeActivityView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *networkErrorAlert = [[UIAlertView alloc] initWithTitle:@"Network Error"
                                                                    message:[error localizedDescription]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
        [networkErrorAlert show];
        [self removeActivityView];
    }];
}


#pragma mark - Dejal Activity View

- (IBAction)displayActivityView {
    UIView *viewToUse = self.navigationController.navigationBar.superview;
    [DejalBezelActivityView activityViewForView:viewToUse];
}

- (void)removeActivityView {
    [DejalBezelActivityView removeViewAnimated:YES];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

@end
