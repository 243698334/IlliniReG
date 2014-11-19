//
//  ExplorerTableViewController.m
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/17/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import "ExplorerTableViewController.h"

@interface ExplorerTableViewController () <UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong, readwrite) NSString *currentExplorerLayer;
@property (nonatomic, strong, readwrite) NSString *currentSelectedEntry;
@property (nonatomic, strong, readwrite) UIProgressView *loadingProgressView;

@property (nonatomic, strong) UIBarButtonItem *confirmButton;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *filteredSearchResults;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, assign) BOOL searchingInProgress;

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundProcess;

@end

@implementation ExplorerTableViewController

#pragma mark - View Lifecycle

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    // custom initialization
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Title and ExplorerLayer
    if (self.title == nil || [self.title isEqualToString:@""]) {
        self.title = @"Course Explorer";
    }
    if (self.currentExplorerLayer == nil) {
        self.currentExplorerLayer = @"";
    }
    
    // Navigation Bar
    self.confirmButton = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStyleDone target:self action:@selector(confirmSectionSelection)];
    self.navigationItem.rightBarButtonItem = self.confirmButton;
    
    // Search Bar
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y,
                                                       self.searchController.searchBar.frame.size.width, 44.0);
    self.tableView.tableHeaderView = self.searchController.searchBar;
    NSMutableArray *scopeButtonTitles = [[NSMutableArray alloc] init];
    [scopeButtonTitles addObject:NSLocalizedString(@"All", @"Search controller filter All button")];
    [scopeButtonTitles addObject:NSLocalizedString(@"Subject", @"Search controller filter Subject button")];
    [scopeButtonTitles addObject:NSLocalizedString(@"CRN", @"Search controller filter CRN button")];
    self.searchController.searchBar.scopeButtonTitles = scopeButtonTitles;
    self.searchController.searchBar.delegate = self;
    self.definesPresentationContext = YES;
    
    // Progress View
    self.loadingProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    CGFloat yOrigin = self.navigationController.navigationBar.bounds.size.height - self.loadingProgressView.bounds.size.height;
    CGFloat widthBoundary = self.navigationController.navigationBar.bounds.size.width;
    CGFloat heigthBoundary = self.loadingProgressView.bounds.size.height;
    self.loadingProgressView.frame = CGRectMake(0, yOrigin, widthBoundary, heigthBoundary);
    self.loadingProgressView.alpha = 0.0;
    self.loadingProgressView.tintColor = [UIColor colorWithRed:0.0/255.0f green:122.0/255.0f blue:255.0/255.0f alpha:1.0f];
    self.loadingProgressView.trackTintColor = [UIColor lightGrayColor];
    [self.navigationController.navigationBar addSubview:self.loadingProgressView];
    
    // Pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor colorWithRed:0.0/255.0f green:122.0/255.0f blue:255.0/255.0f alpha:1.0f];
    [self.refreshControl addTarget:self action:@selector(updateContent) forControlEvents:UIControlEventValueChanged];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSArray *sourceArray = self.searchController.active ? self.filteredSearchResults : self.currentEntries;
    UIViewController *destinationController = segue.destinationViewController;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // No entries
    if ([self.currentEntries count] == 0) {
        
    }
    
    return nil;
}

#pragma mark - DataController Delegate

- (void)confirmSectionSelection {
    
}

#pragma mark - Content Refresh
- (void)updateContent {
    
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
