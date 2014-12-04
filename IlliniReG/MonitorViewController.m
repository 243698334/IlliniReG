//
//  MonitorTableViewController.m
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/17/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import "MonitorViewController.h"

@interface MonitorViewController ()

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, readonly) NSUInteger ActiveMonitorsSectionIndex;
@property (nonatomic, readonly) NSUInteger InactiveMonitorsSectionIndex;
@property (nonatomic, readonly) NSUInteger SucceededMonitorsSectionIndex;

@property (nonatomic, strong) NSMutableArray *monitors;

@end

@implementation MonitorViewController

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Monitor Panel";
    
    // Prevent retain cycle
    __unsafe_unretained __block MonitorViewController *safeSelf = self;
    
    // Add New section
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"AddNewMonitorCell";
            cell.textLabel.text = @"Add New...";
        } whenSelected:^(NSIndexPath *indexPath) {
            MonitorSettingsViewController *monitorSettingsViewController = [[MonitorSettingsViewController alloc] initWithMonitor:nil];
            [safeSelf.navigationController pushViewController:monitorSettingsViewController animated:YES];
        }];
    }];
    
    // Active Monitors section
    _ActiveMonitorsSectionIndex = 1;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.headerTitle = @"Active Monitors";
        NSString *numberOfMonitors = [safeSelf.monitors count] == 0 ? @"no" : [NSString stringWithFormat:@"%zd", [safeSelf.monitors count]];
        NSString *monitorPlural = [safeSelf.monitors count] == 1 ? @"" : @"s";
        section.footerTitle = [NSString stringWithFormat:@"Currently you have %@ running monitor%@.", numberOfMonitors, monitorPlural];
    }];
    
    // Inactive Monitors section
    _InactiveMonitorsSectionIndex = 2;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.headerTitle = @"Inactive Monitors";
        NSString *numberOfMonitors = [safeSelf.monitors count] == 0 ? @"no" : [NSString stringWithFormat:@"%zd", [safeSelf.monitors count]];
        NSString *monitorPlural = [safeSelf.monitors count] == 1 ? @"" : @"s";
        section.footerTitle = [NSString stringWithFormat:@"Currently you have %@ idle monitor%@.", numberOfMonitors, monitorPlural];
    }];
    
    // Succeeded Monitors section
    _SucceededMonitorsSectionIndex = 3;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.headerTitle = @"Succeeded Monitors";
        NSString *monitorPlural = [safeSelf.monitors count] == 1 ? @"" : @"s";
        NSString *failedFooterTitle = @"None of your monitors has successfully registered the selected sections yet.";
        NSString *succeededFooterTitle = [NSString stringWithFormat:@"Yay! You have %zd monitor%@ completed the registration for your courses!", [safeSelf.monitors count], monitorPlural];
        section.footerTitle = [safeSelf.monitors count] == 0 ? failedFooterTitle : succeededFooterTitle;
    }];
    
    // Pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor colorWithRed:0.0/255.0f green:122.0/255.0f blue:255.0/255.0f alpha:1.0f];
    [self.refreshControl addTarget:self action:@selector(retrieveMonitorList:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleDone target:self action:@selector(jumpToSettingsView)];
    self.navigationItem.rightBarButtonItem = settingsButton;
    
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [self retrieveMonitorList:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view data source

- (void)retrieveMonitorList:(UIRefreshControl *)sender {
    if (sender == nil) {
        [self displayActivityView];
    }
    
    // Clear all current sections for refresh
    if (_monitors != nil || [_monitors count] == 0) {
        [[self sectionAtIndex:_ActiveMonitorsSectionIndex] removeAllCells];
        [self reloadSectionAtIndex:_ActiveMonitorsSectionIndex animated:NO];
        [[self sectionAtIndex:_InactiveMonitorsSectionIndex] removeAllCells];
        [self reloadSectionAtIndex:_InactiveMonitorsSectionIndex animated:NO];
        [[self sectionAtIndex:_SucceededMonitorsSectionIndex] removeAllCells];
        [self reloadSectionAtIndex:_SucceededMonitorsSectionIndex animated:NO];
    }
    
    NSString *retrieveMonitorListURL = [MonitorAPI stringByAppendingString:@"ychen131.json"];
    retrieveMonitorListURL = @"http://localhost:3000/api/v1/ir_monitor_data/ychen131.json";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:retrieveMonitorListURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _monitors = [[NSMutableArray alloc] init];
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        for (NSDictionary *currentMonitorDictionary in [responseDictionary valueForKey:@"monitors"]) {
            IRMonitor *currentMonitor = [[IRMonitor alloc] init];
            currentMonitor.monitorID = [currentMonitorDictionary valueForKey:@"monitorId"];
            currentMonitor.netID = [currentMonitorDictionary valueForKey:@"netId"];
            currentMonitor.name = [currentMonitorDictionary valueForKey:@"monitorName"];
            currentMonitor.autoRegister = [[currentMonitorDictionary valueForKey:@"autoRegister"] boolValue];
            currentMonitor.refreshFrequency = [currentMonitorDictionary valueForKey:@"refreshFrequency"];
            currentMonitor.userAgentContent = [currentMonitorDictionary valueForKey:@"userAgentContent"];
            currentMonitor.userAgentType = [currentMonitorDictionary valueForKey:@"userAgentType"];
            currentMonitor.pushNotification = [[currentMonitorDictionary valueForKey:@"pushNotification"] boolValue];
            currentMonitor.smsNumber = [currentMonitorDictionary valueForKey:@"smsNumber"];
            currentMonitor.email = [currentMonitorDictionary valueForKey:@"email"];
            currentMonitor.status = [IRMonitor stringToStatus:[currentMonitorDictionary valueForKey:@"monitorStatus"]];
            NSMutableArray *currentEntries = [[NSMutableArray alloc] init];
            for (NSDictionary *currentSectionDictionary in [currentMonitorDictionary valueForKey:@"sections"]) {
                IRSectionEntry *currentSectionEntry = [[IRSectionEntry alloc] init];
                currentSectionEntry.section = [currentSectionDictionary valueForKey:@"section"];
                currentSectionEntry.crn = [currentSectionDictionary valueForKey:@"crn"];
                [currentEntries addObject:currentSectionEntry];
            }
            currentMonitor.entries = [currentEntries copy];
            [_monitors addObject:currentMonitor];
        }
        [self updateTableData:sender];
        if (sender == nil) {
            [self removeActivityView];
        } else {
            [self.refreshControl endRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self updateTableData:sender];
        if (sender == nil) {
            [self removeActivityView];
        } else {
            [self.refreshControl endRefreshing];
        }
        UIAlertView *networkErrorAlert = [[UIAlertView alloc] initWithTitle:@"Network Error"
                                                                    message:[error localizedDescription]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
        [networkErrorAlert show];
    }];
    
    
}

- (void)updateTableData:(UIRefreshControl *)sender {
    [self.tableView beginUpdates];
        
    // Insert into sections
    NSInteger numberOfActiveMonitors = 0, numberOfInactiveMonitors = 0, numberOfSucceededMonitors = 0;
    for (IRMonitor *currentMonitor in _monitors) {
        NSUInteger currentSectionIndex = _InactiveMonitorsSectionIndex, currentSectionCounter = numberOfInactiveMonitors;
        switch (currentMonitor.status) {
            case ON:
                currentSectionIndex = _ActiveMonitorsSectionIndex;
                currentSectionCounter = numberOfActiveMonitors;
                break;
            case OFF:
                currentSectionIndex = _InactiveMonitorsSectionIndex;
                currentSectionCounter = numberOfInactiveMonitors;
                break;
            case SUCCESS:
                currentSectionIndex = _SucceededMonitorsSectionIndex;
                currentSectionCounter = numberOfSucceededMonitors;
                break;
            default:
                break;
        }
        [self insertCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"MonitorListCell";
            staticContentCell.cellStyle = UITableViewCellStyleSubtitle;
            cell.textLabel.text = currentMonitor.name;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%zd sections", [currentMonitor.entries count]];
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        } whenSelected:^(NSIndexPath *indexPath ) {
            MonitorSettingsViewController *currentMonitorSettingsViewController = [[MonitorSettingsViewController alloc] initWithMonitor:currentMonitor];
            [self.navigationController pushViewController:currentMonitorSettingsViewController animated:YES];
        } atIndexPath:[NSIndexPath indexPathForRow:currentSectionCounter++ inSection:currentSectionIndex] animated:YES];
        
        NSString *numberOfMonitors = currentSectionCounter == 0 ? @"no" : [NSString stringWithFormat:@"%zd", currentSectionCounter];
        NSString *monitorPlural = currentSectionCounter == 1 ? @"" : @"s";
        
        switch (currentMonitor.status) {
            case ON: {
                numberOfActiveMonitors = currentSectionCounter;
                [self sectionAtIndex:_ActiveMonitorsSectionIndex].footerTitle = [NSString stringWithFormat:@"Currently you have %@ running monitor%@.", numberOfMonitors, monitorPlural];
                break;
            }
            case OFF: {
                numberOfInactiveMonitors = currentSectionCounter;
                [self sectionAtIndex:_InactiveMonitorsSectionIndex].footerTitle = [NSString stringWithFormat:@"Currently you have %@ idle monitor%@.", numberOfMonitors, monitorPlural];
                break;
            }
            case SUCCESS: {
                numberOfSucceededMonitors = currentSectionCounter;
                NSString *failedFooterTitle = @"None of your monitors has successfully registered the selected sections yet.";
                NSString *succeededFooterTitle = [NSString stringWithFormat:@"Yay! You have %@ monitor%@ completed the registration for your courses!", numberOfMonitors, monitorPlural];
                [self sectionAtIndex:_SucceededMonitorsSectionIndex].footerTitle = currentSectionCounter == 0 ? failedFooterTitle : succeededFooterTitle;
                break;
            }
            default:
                break;
        }
    }
    
    [self.tableView endUpdates];
}


- (void)jumpToSettingsView {
    MonitorSettingsViewController *monitorSettingsViewController = [[MonitorSettingsViewController alloc] init];
    [self.navigationController pushViewController:monitorSettingsViewController animated:YES];
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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
