//
//  SideMenuViewController.m
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/17/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import "SideMenuViewController.h"
#import "UIViewController+RESideMenu.h"
#import "MonitorViewController.h"
#import "HomeViewController.h"
#import "ExplorerViewController.h"

@interface SideMenuViewController () {
    NSArray *titles;
    NSArray *icons;
}

@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    titles = @[@"Profile", @"Home", @"Monitor", @"Explorer", @"Wish List", @"Log Out", @"Test"];
    icons = @[@"IconProfile", @"IconHome", @"IconMonitor", @"IconCalendar", @"IconWishList", @"IconLogout", @"IconEmpty"];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 5) / 2.0f, self.view.frame.size.width, 54 * 5) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView.scrollsToTop = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"profile"]] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 1:
            //[self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"home"]] animated:YES];
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 2:
            //[self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"monitor"]] animated:YES];
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[MonitorViewController alloc] init]] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 3:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"explorer"]]animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 4:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"wishList"]]animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return [titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
//    NSArray *titles = @[@"Profile", @"Home", @"Monitor", @"Explorer", @"Settings", @"Log Out"];
//    NSArray *images = @[@"IconProfile", @"IconHome", @"IconProfile", @"IconCalendar", @"IconSettings", @"IconEmpty"];
    
    cell.textLabel.text = titles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:icons[indexPath.row]];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
