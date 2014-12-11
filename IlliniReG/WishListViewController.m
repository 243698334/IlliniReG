//
//  WishListViewController.m
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/30/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import "WishListViewController.h"

@interface WishListViewController ()

@property (nonatomic) BOOL wishListAndMonitorListLoaded;
@property (nonatomic, readonly) NSUInteger WishListSectionIndex;
@property (nonatomic, readonly) NSUInteger MonitorsSectionIndex;

@end

@implementation WishListViewController

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (id)initWithWishList:(IRWishList *)wishList {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        _wishList = wishList;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Prevent retain cycle
    __unsafe_unretained __block WishListViewController *safeSelf = self;
    
    // Load existing wish list
    [self loadWishListAndMonitorList];
    
    // Title
    self.title = @"Wish List";
    
    // Wish List
    _WishListSectionIndex = 0;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.headerTitle = @"Wish List Entries";
    }];
    
    // Wish List Buttons
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"GenerateMonitorsCell";
            staticContentCell.cellStyle = UITableViewCellStyleDefault;
            cell.textLabel.text = @"Generate Monitors";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor blueColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
        } whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.tableView deselectRowAtIndexPath:indexPath animated:NO];
            //
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"RemoveAllCell";
            staticContentCell.cellStyle = UITableViewCellStyleDefault;
            cell.textLabel.text = @"Remove All";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor redColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
        } whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.tableView deselectRowAtIndexPath:indexPath animated:NO];
            //
        }];
        section.footerTitle = @"These are the section you selected from the Course Explorer. You can continue adding more sections.";
    }];
    
    // Monitor List
    _MonitorsSectionIndex = 2;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.headerTitle = @"Monitors";
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"AddMonitorCell";
            cell.textLabel.text = @"Add Monitor...";
        } whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }];
    }];
    
    // Monitor List Buttons
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"SubmitMonitorsButton";
            staticContentCell.cellStyle = UITableViewCellStyleDefault;
            cell.textLabel.text = @"Submit";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor blueColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
        } whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.tableView deselectRowAtIndexPath:indexPath animated:NO];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"RemoveAllCell";
            staticContentCell.cellStyle = UITableViewCellStyleDefault;
            cell.textLabel.text = @"Clear All";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor redColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
        } whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.tableView deselectRowAtIndexPath:indexPath animated:NO];
            
        }];
        section.footerTitle = @"These are the monitors generated from your Wish List. Click Submit to confirm creating the monitors above.";
    }];
    
    _wishListAndMonitorListLoaded = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_wishListAndMonitorListLoaded) {
        [self loadWishListAndMonitorList];
    }
}

- (void)loadWishListAndMonitorList {
    _wishListAndMonitorListLoaded = YES;
    
    NSString *currentUserNetID = @"_shared";
    NSData *wishListDictionaryData = [[NSUserDefaults standardUserDefaults] objectForKey:@"WishList"];
    NSMutableDictionary *wishListDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:wishListDictionaryData];
    NSMutableArray *wishListArray = [wishListDictionary objectForKey:currentUserNetID];
    
    [self.tableView beginUpdates];
    for (NSUInteger i = 0; i < [wishListArray count]; i++) {
        IRSectionEntry *currentSectionEntry = [wishListArray objectAtIndex:i];
        [self insertCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"SectionCell";
            staticContentCell.cellStyle = UITableViewCellStyleSubtitle;
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@, %@", currentSectionEntry.subject, currentSectionEntry.course, currentSectionEntry.section];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"CRN: %@", currentSectionEntry.crn];
        } atIndexPath:[NSIndexPath indexPathForItem:i inSection:_WishListSectionIndex] animated:YES];
    }
    [self.tableView endUpdates];
}

- (void)generateMonitors {
    
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
