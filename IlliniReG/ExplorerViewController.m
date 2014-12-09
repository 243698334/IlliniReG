//
//  ExplorerTableViewController.m
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/17/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import "ExplorerViewController.h"

@interface ExplorerViewController () {
    UIProgressView *loadingProgressView;
    UISearchController *searchController;
    UIBarButtonItem *addToWishListButtonItem;
    
    BOOL searchingInProgress;
    NSArray *entries;
    NSArray *indexedEntries;
    NSArray *indexedEntriesSectionTitles;
    NSMutableArray *filteredSearchResults;
}

@end

@implementation ExplorerViewController

- (instancetype)initWithExplorerEntryType:(IRExplorerEntryType)type {
    if (self = [super init]) {
        _explorerEntryType = type;
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    _explorerURL = [[NSURL alloc] initWithString:CISAppAPIBaseURL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Title
    if (self.title == nil || [self.title isEqualToString:@""]) {
        self.title = @"Course Explorer";
    }
    
    // Navigation Bar
    if (_explorerEntryType == SECTION) {
        addToWishListButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Wish List" style:UIBarButtonItemStyleDone target:self action:@selector(pushWishListViewController)];
        self.navigationItem.rightBarButtonItem = addToWishListButtonItem;
    }
    
    // Search Bar
    searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchResultsUpdater = self;
    searchController.dimsBackgroundDuringPresentation = NO;
    searchController.hidesNavigationBarDuringPresentation = NO;
    searchController.searchBar.frame = CGRectMake(searchController.searchBar.frame.origin.x, searchController.searchBar.frame.origin.y,
                                                       searchController.searchBar.frame.size.width, 44.0);
    self.tableView.tableHeaderView = searchController.searchBar;
    NSMutableArray *scopeButtonTitles = [[NSMutableArray alloc] init];
    [scopeButtonTitles addObject:@"Current List"];
    [scopeButtonTitles addObject:@"All"];
    [scopeButtonTitles addObject:@"CRN"];
    searchController.searchBar.scopeButtonTitles = scopeButtonTitles;
    searchController.searchBar.delegate = self;
    self.definesPresentationContext = YES;
    
    // Progress View
    loadingProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    CGFloat yOrigin = self.navigationController.navigationBar.bounds.size.height - loadingProgressView.bounds.size.height;
    CGFloat widthBoundary = self.navigationController.navigationBar.bounds.size.width;
    CGFloat heigthBoundary = loadingProgressView.bounds.size.height;
    loadingProgressView.frame = CGRectMake(0, yOrigin, widthBoundary, heigthBoundary);
    loadingProgressView.alpha = 0.0;
    loadingProgressView.tintColor = [UIColor colorWithRed:0.0/255.0f green:122.0/255.0f blue:255.0/255.0f alpha:1.0f];
    loadingProgressView.trackTintColor = [UIColor lightGrayColor];
    [self.navigationController.navigationBar addSubview:loadingProgressView];
    
    // Pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor colorWithRed:0.0/255.0f green:122.0/255.0f blue:255.0/255.0f alpha:1.0f];
    [self.refreshControl addTarget:self action:@selector(loadDataToTableView:) forControlEvents:UIControlEventValueChanged];
    
    // Table Entries
    [self loadDataToTableView];
    self.tableView.allowsMultipleSelection = YES;
}


#pragma mark - Table view

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([entries count] == 0) {
        // No entries
        if (indexPath.row == 1) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            if (searchingInProgress) {
                cell.textLabel.text = @"No Search Results";
            } else {
                cell.textLabel.text = @"Please wait...";
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
        
        IRExplorerEntry *currentEntry = (_explorerEntryType == SUBJECT || _explorerEntryType == COURSE) ?
            [[indexedEntries objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] : [entries objectAtIndex:indexPath.row];
        cell.textLabel.text = [[currentEntry title] isEqual: @""] ? @"Default" : [currentEntry title];
        cell.detailTextLabel.text = [currentEntry subtitle];
        [cell.textLabel setNeedsDisplay];
        [cell.detailTextLabel setNeedsDisplay];
        if ([currentEntry type] != SECTION) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            NSString *enrollmentStatus = currentEntry.sectionEntry.enrollmentStatus;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"CRN: %@, Status: %@", cell.detailTextLabel.text, enrollmentStatus];
            if ([enrollmentStatus isEqualToString:@"Open"]) {
                cell.imageView.image = [UIImage imageNamed:@"statusGreen"];
            } else if ([enrollmentStatus isEqualToString:@"Closed"]) {
                cell.imageView.image = [UIImage imageNamed:@"statusRed"];
            } else {
                cell.imageView.image = [UIImage imageNamed:@"statusYellow"];
            }
            
            // Match Wish List
            NSString *currentUserNetID = @"_shared";
            NSData *wishListDictionaryData = [[NSUserDefaults standardUserDefaults] objectForKey:@"WishList"];
            if (wishListDictionaryData == nil) {
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            } else {
                BOOL isInWishList = NO;
                NSMutableDictionary *wishListDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:wishListDictionaryData];
                NSMutableArray *wishListArray = [wishListDictionary objectForKey:currentUserNetID];
                for (IRSectionEntry *currentWishListSectionEntry in wishListArray) {
                    if ([currentWishListSectionEntry.crn isEqualToString:currentEntry.sectionEntry.crn]) {
                        isInWishList = YES;
                        break;
                    }
                }
                if (isInWishList) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                } else {
                    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                }
            }

        }

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([entries count] == 0) {
        // No entries
    } else {
        // Selected Entry
        IRExplorerEntry *currentSelectedEntry = (_explorerEntryType == SUBJECT || _explorerEntryType == COURSE) ?
            [[indexedEntries objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] : [entries objectAtIndex:indexPath.row];
        if ([currentSelectedEntry type] == SECTION) {
            if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryDetailDisclosureButton) {
                // select
                [self updateWishList:currentSelectedEntry removed:NO];
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                // deselect
                [self updateWishList:currentSelectedEntry removed:YES];
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            }
        } else {
            _subLayerExplorerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"explorer"];
            _subLayerExplorerViewController.explorerEntryType = [currentSelectedEntry type] + 1;
            _subLayerExplorerViewController.title = currentSelectedEntry.title;
            _subLayerExplorerViewController.explorerURL = currentSelectedEntry.subLayerURL;
            
            [self.navigationController pushViewController:_subLayerExplorerViewController animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_explorerEntryType == SUBJECT || _explorerEntryType == COURSE) {
        return [indexedEntriesSectionTitles count];
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([entries count] == 0) {
        // When no entries, show message at the 2nd row
        return 2;
    }
    if (_explorerEntryType == SUBJECT || _explorerEntryType == COURSE) {
        return [[indexedEntries objectAtIndex:section] count];
    } else {
        return [entries count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_explorerEntryType == SUBJECT) {
        return [indexedEntriesSectionTitles objectAtIndex:section];
    } else if (_explorerEntryType == COURSE) {
        return [[indexedEntriesSectionTitles objectAtIndex:section] stringByAppendingString:@"00 Level Courses"];
    } else {
        return nil;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (_explorerEntryType == SUBJECT || _explorerEntryType == COURSE) {
        return indexedEntriesSectionTitles;
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (_explorerEntryType == SUBJECT || _explorerEntryType == COURSE) {
        return [indexedEntriesSectionTitles indexOfObject:title];
    } else {
        return NSNotFound;
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
    searchingInProgress = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchingInProgress = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    searchingInProgress = YES;
    if ([searchBar.text isEqualToString:@""] || searchBar.text == nil) {
        
    } else {
        
    }
}

#pragma mark - Content

- (void)updateTableData {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}

- (void)loadDataToTableView {
    [self loadDataToTableView:nil];
}

- (void)loadDataToTableView:(UIRefreshControl *)refreshControl {
    NSLog(@"Loading data from URL: %@", _explorerURL);
    if (refreshControl == nil) {
        [self performSelector:@selector(displayActivityView) withObject:nil afterDelay:0.2];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[_explorerURL absoluteString] parameters:nil success:^(AFHTTPRequestOperation *operation, NSData* xmlData) {
        if (xmlData != nil) {
            NSLog(@"Received XML Data.");
            RXMLElement *xmlElement = [RXMLElement elementFromXMLData:xmlData];
            NSMutableArray *currentEntries = [[NSMutableArray alloc] init];
            IRExplorerEntryType listEntryType = [IRExplorerEntry xmlTagToType:xmlElement.tag] + 1;
            
            [xmlElement iterate:[[[IRExplorerEntry typeToXMLTag:listEntryType plural:YES] stringByAppendingString:@"."] stringByAppendingString:[IRExplorerEntry typeToXMLTag:listEntryType plural:NO]] usingBlock: ^(RXMLElement *entry) {
                IRExplorerEntry *currentEntry = [[IRExplorerEntry alloc] initWithXMLID:[entry attribute:@"id"] text:entry.text href:[entry attribute:@"href"] type:entry.tag];
                if (listEntryType == SECTION) {
                    currentEntry.sectionEntry = [[IRSectionEntry alloc] init];
                    NSURLRequest *currentSectionURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[entry attribute:@"href"]]];
                    NSURLResponse *response = nil;
                    NSError *error = nil;
                    NSData *sectionXMLData = [NSURLConnection sendSynchronousRequest:currentSectionURLRequest returningResponse:&response error:&error];
                    if (sectionXMLData != nil) {
                        RXMLElement *sectionXMLElement = [RXMLElement elementFromXMLData:sectionXMLData];
                        currentEntry.sectionEntry.year = [[sectionXMLElement child:@"parents"] child:@"calendarYear"].text;
                        currentEntry.sectionEntry.semester = [[sectionXMLElement child:@"parents"] child:@"term"].text;
                        currentEntry.sectionEntry.subject = [[[sectionXMLElement child:@"parents"] child:@"subject"] attribute:@"id"];
                        currentEntry.sectionEntry.course = [[[sectionXMLElement child:@"parents"] child:@"course"] attribute:@"id"];
                        currentEntry.sectionEntry.section = [sectionXMLElement child:@"sectionNumber"].text;
                        currentEntry.sectionEntry.crn = [sectionXMLElement attribute:@"id"];
                        currentEntry.sectionEntry.statusCode = [sectionXMLElement child:@"statusCode"].text;
                        currentEntry.sectionEntry.partOfTerm = [sectionXMLElement child:@"partOfTerm"].text;
                        currentEntry.sectionEntry.sectionStatusCode = [sectionXMLElement child:@"sectionStatusCode"].text;
                        currentEntry.sectionEntry.enrollmentStatus = [sectionXMLElement child:@"enrollmentStatus"].text;
                        currentEntry.sectionEntry.startDate = [sectionXMLElement child:@"startDate"].text;
                        currentEntry.sectionEntry.endDate = [sectionXMLElement child:@"endDate"].text;
                    }
                }
                [currentEntries addObject:currentEntry];
            }];
            entries = [currentEntries copy];
            if (_explorerEntryType == SUBJECT || _explorerEntryType == COURSE) {
                [self indexEntries];
            }
            [self updateTableData];
        }
        if (refreshControl == nil) {
            [self removeActivityView];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *networkErrorAlert = [[UIAlertView alloc] initWithTitle:@"Network Error"
                                                                    message:@"Please check your Internet connection."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
        [networkErrorAlert show];
        [self removeActivityView];
    }];
}

- (void)indexEntries {
    NSMutableArray *currentIndexedEntries = [[NSMutableArray alloc] init];
    NSMutableDictionary *currentIndexedEntriesDictionary = [[NSMutableDictionary alloc] init];
    for (IRExplorerEntry *currentUnindexedEntry in entries) {
        NSString *currentTargetKey = [[currentUnindexedEntry.title substringToIndex:1] uppercaseString];
        if ([currentIndexedEntriesDictionary objectForKey:currentTargetKey] == nil) {
            [currentIndexedEntriesDictionary setObject:[[NSMutableArray alloc] init] forKey:currentTargetKey];
        }
        [[currentIndexedEntriesDictionary objectForKey:currentTargetKey] addObject:currentUnindexedEntry];
    }
    indexedEntriesSectionTitles = [[currentIndexedEntriesDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    for (NSString *currentIndexedEntriesSectionTitle in indexedEntriesSectionTitles) {
        [currentIndexedEntries insertObject:[currentIndexedEntriesDictionary objectForKey:currentIndexedEntriesSectionTitle]
                                    atIndex:[indexedEntriesSectionTitles indexOfObject:currentIndexedEntriesSectionTitle]];
    }
    indexedEntries = [currentIndexedEntries copy];
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

#pragma mark - Wish List

- (void)updateWishList:(IRExplorerEntry *)entry removed:(BOOL)isRemoved {
    NSString *currentUserNetID = @"_shared";
    NSMutableDictionary *wishListDictionary = nil;
    NSMutableArray *wishListArray = nil;
    NSData *wishListDictionaryData = [[NSUserDefaults standardUserDefaults] objectForKey:@"WishList"];
    if (wishListDictionaryData == nil) {
        NSLog(@"Creating new Wish List for %@", currentUserNetID);
        wishListDictionary = [[NSMutableDictionary alloc] init];
        wishListArray = [[NSMutableArray alloc] init];
    } else {
        wishListDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:wishListDictionaryData];
        wishListArray = [[wishListDictionary objectForKey:currentUserNetID] mutableCopy];
        if (wishListArray == nil) {
            wishListArray = [[NSMutableArray alloc] init];
        }
    }
    if (isRemoved) {
        [wishListArray removeObject:entry.sectionEntry];
    } else {
        [wishListArray addObject:entry.sectionEntry];
    }
    [wishListDictionary setObject:wishListArray forKey:currentUserNetID];
    wishListDictionaryData = [NSKeyedArchiver archivedDataWithRootObject:wishListDictionary];
    [[NSUserDefaults standardUserDefaults] setObject:wishListDictionaryData forKey:@"WishList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)pushWishListViewController {
    WishListViewController *wishListViewController = [[WishListViewController alloc] init];
    [self.navigationController pushViewController:wishListViewController animated:YES];
}

@end
