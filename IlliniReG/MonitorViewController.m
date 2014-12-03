//
//  MonitorTableViewController.m
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/17/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import "MonitorViewController.h"

@interface MonitorViewController () 

@property (nonatomic, strong) UIActivityIndicatorView *activeMonitorsActivityIndicatorView;
@property (nonatomic, strong) UIActivityIndicatorView *inactiveMonitorsActivityIndicatorView;
@property (nonatomic, strong) UIActivityIndicatorView *succeededMonitorsActivityIndicatorView;

@property (nonatomic, strong) NSMutableArray *monitors;

@end

@implementation MonitorViewController

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_activeMonitorsActivityIndicatorView startAnimating];
    [_inactiveMonitorsActivityIndicatorView startAnimating];
    [_succeededMonitorsActivityIndicatorView startAnimating];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Monitor Panel";
    
    [self retrieveMonitorList];

    // Prevent retain cycle
    __unsafe_unretained __block MonitorViewController *safeSelf = self;
    
    // Add New
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"AddNewMonitorCell";
            cell.textLabel.text = @"Add New...";
        } whenSelected:^(NSIndexPath *indexPath) {
            MonitorSettingsViewController *monitorSettingsViewController = [[MonitorSettingsViewController alloc] initWithMonitor:nil];
            [safeSelf.navigationController pushViewController:monitorSettingsViewController animated:YES];
        }];
        safeSelf.activeMonitorsActivityIndicatorView.frame = CGRectMake(190.0, 18.0, 0.0, 0.0);
        [[safeSelf.tableView headerViewForSection:1] addSubview:safeSelf.activeMonitorsActivityIndicatorView];
    }];
    
    // Active Monitors
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.headerTitle = @"Active Monitors";
        NSString *numberOfMonitors = [safeSelf.monitors count] == 0 ? @"no" : [NSString stringWithFormat:@"%zd", [safeSelf.monitors count]];
        NSString *monitorPlural = [safeSelf.monitors count] == 1 ? @"" : @"s";
        section.footerTitle = [NSString stringWithFormat:@"Currently you have %@ running monitor%@.", numberOfMonitors, monitorPlural];
    }];
    
    // Inactive Monitors
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.headerTitle = @"Inactive Monitors";
        NSString *numberOfMonitors = [safeSelf.monitors count] == 0 ? @"no" : [NSString stringWithFormat:@"%zd", [safeSelf.monitors count]];
        NSString *monitorPlural = [safeSelf.monitors count] == 1 ? @"" : @"s";
        section.footerTitle = [NSString stringWithFormat:@"Currently you have %@ idle monitor%@.", numberOfMonitors, monitorPlural];
    }];
    
    // Succeeded Monitors
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.headerTitle = @"Succeeded Monitors";
        NSString *monitorPlural = [safeSelf.monitors count] == 1 ? @"" : @"s";
        NSString *failedFooterTitle = @"None of your monitors has successfully registered the selected sections yet.";
        NSString *succeededFooterTitle = [NSString stringWithFormat:@"Yay! You have %zd monitor%@ completed the registration for your courses!", [safeSelf.monitors count], monitorPlural];
        section.footerTitle = [safeSelf.monitors count] == 0 ? failedFooterTitle : succeededFooterTitle;
    }];
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleDone target:self action:@selector(jumpToSettingsView)];
    self.navigationItem.rightBarButtonItem = settingsButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View delegate

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 1) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 16.0)];
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 10.0, 320.0, 16.0)];
        
        headerLabel.backgroundColor = [tableView backgroundColor];
        headerLabel.text = NSLocalizedString(@"Choose a Network...", @"Choose a Network...");
        headerLabel.font = [UIFont boldSystemFontOfSize:16.0];
        headerLabel.textColor = [UIColor colorWithRed:61.0/255.0 green:77.0/255.0 blue:99.0/255.0 alpha:1.0];
        headerLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.65];
        headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        
        [header addSubview:headerLabel];
        
        _activeMonitorsActivityIndicatorView.frame = CGRectMake(190.0, 18.0, 0.0, 0.0);
        [header addSubview:_activeMonitorsActivityIndicatorView];
        
        return header;
    } else {
        return nil;
    }
}



#pragma mark - Table view data source

- (void)retrieveMonitorList {
    //[self.tableView beginUpdates];
    for (NSInteger i = 0; i < [_monitors count]; i++) {
        
    }
    
//    [_activeMonitorsActivityIndicatorView stopAnimating];
//    [_inactiveMonitorsActivityIndicatorView stopAnimating];
//    [_succeededMonitorsActivityIndicatorView stopAnimating];
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
