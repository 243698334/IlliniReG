//
//  ExplorerTableViewController.m
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/17/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import "ExplorerViewController.h"

@interface ExplorerViewController () <UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong, readwrite) NSString *currentExplorerLayer;
@property (nonatomic, strong, readwrite) UIProgressView *loadingProgressView;
@property (nonatomic, strong) UIBarButtonItem *confirmButton;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *filteredSearchResults;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, assign) BOOL searchingInProgress;
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundProcess;
@property (nonatomic, assign) BOOL shouldDisplaySearchBar;

@property (nonatomic, strong) NSMutableArray *currentEntries;

@property (nonatomic, strong) ExplorerViewController *subLayerExplorerViewController;

@end

@implementation ExplorerViewController

#pragma mark - View Lifecycle

- (instancetype)initWithYear:(NSString *)year semester:(NSString *)semester subject:(NSString *)subject course:(NSString *)course {
    self = [super init];
    if (self) {
        _currentYear = year;
        _currentSemester = semester;
        _currentSubject = subject;
        _currentCourse = course;
        _currentSection = nil;
    }
    return self;
}

- (void)awakeFromNib {
    _currentExplorerURL = [[NSURL alloc] initWithString:CISAppAPIBaseURL];
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
    //self.confirmButton = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStyleDone target:self action:@selector(confirmSectionSelection)];
    // self.navigationItem.rightBarButtonItem = self.confirmButton;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
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
    [self.refreshControl addTarget:self action:@selector(loadDataToTableView) forControlEvents:UIControlEventValueChanged];
    
    // Table Entries
    [self loadDataToTableView];
}


#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_currentEntries count] == 0) {
        // When no entries, show message at the 2nd row
        return 2;
    } else {
        return [_currentEntries count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_currentEntries count] == 0) {
        // No entries
        if (indexPath.row == 1) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            if (self.searchingInProgress) {
                cell.textLabel.text = @"No Search Results";
            } else {
                cell.textLabel.text = @"Network Error";
            }
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor darkGrayColor];
            return cell;
        } else {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            return cell;
        }
    } else {
        // Has entries
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExplorerEntryCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ExplorerEntryCell"];
        }
        
        IRExplorerListEntry *entry = (IRExplorerListEntry *)_currentEntries[indexPath.row];
        cell.textLabel.text = [entry title];
        cell.detailTextLabel.text = [entry subtitle];
        [cell.textLabel setNeedsDisplay];
        [cell.detailTextLabel setNeedsDisplay];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_currentEntries count] == 0) {
        // No entries
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        // Selected Entry
        IRExplorerListEntry *currentSelectedEntry = (IRExplorerListEntry *)_currentEntries[indexPath.row];
        if ([currentSelectedEntry type] == SECTION) {
            
        } else {
            NSString *subLayerYear = nil, *subLayerSemester = nil, *subLayerSubject = nil, *subLayerCourse = nil;
            if (_currentYear == nil) {
                subLayerYear = currentSelectedEntry.title;
            } else if (_currentSemester == nil) {
                subLayerSemester = currentSelectedEntry.title;
            } else if (_currentSubject == nil) {
                subLayerSubject = currentSelectedEntry.title;
            } else if (_currentCourse == nil) {
                subLayerCourse = currentSelectedEntry.title;
            }
            _subLayerExplorerViewController = [[ExplorerViewController alloc] initWithYear:subLayerYear semester:subLayerSemester subject:subLayerSubject course:subLayerCourse];
            _subLayerExplorerViewController.shouldDisplaySearchBar = self.shouldDisplaySearchBar;
            _subLayerExplorerViewController.title = currentSelectedEntry.title;
            _subLayerExplorerViewController.currentExplorerURL = currentSelectedEntry.subLayerURL;
            [_subLayerExplorerViewController loadDataToTableView];
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self.navigationController pushViewController:_subLayerExplorerViewController animated:YES];
        }
    }
}

#pragma Search Bar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    _searchingInProgress = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    _searchingInProgress = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _searchingInProgress = YES;
    if ([searchBar.text isEqualToString:@""] || searchBar.text == nil) {
        
    } else {
        
    }
}

#pragma mark - Content Refresh

- (void)updateTableData {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}


- (void)loadDataToTableView {
    NSLog(@"Loading data from URL: %@", _currentExplorerURL);
    [AppDelegate downloadDataFromURL:_currentExplorerURL withCompletionHandler:^(NSData *xmlData) {
        if (xmlData != nil) {
            NSLog(@"Received XML Data.");
            RXMLElement *xmlElement = [RXMLElement elementFromXMLData:xmlData];
            NSMutableArray *entries = [[NSMutableArray alloc] init];
            IRExplorerListEntryType listEntryType = [IRExplorerListEntry xmlTagToType:xmlElement.tag] + 1;
            [xmlElement iterate:[[[IRExplorerListEntry typeToXMLTag:listEntryType plural:YES] stringByAppendingString:@"."] stringByAppendingString:[IRExplorerListEntry typeToXMLTag:listEntryType plural:NO]] usingBlock: ^(RXMLElement *entry) {
                IRExplorerListEntry *currentEntry = [[IRExplorerListEntry alloc] initWithXMLID:[entry attribute:@"id"] text:entry.text href:[entry attribute:@"href"] type:entry.tag];
                [entries addObject:currentEntry];
            }];
            _currentEntries = entries;
            [self updateTableData];
        }
    }];
    
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
