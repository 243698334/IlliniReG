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
    NSMutableArray *selectedEntries;
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
        addToWishListButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add to Wish List" style:UIBarButtonItemStyleDone target:self action:@selector(addSectionsToWishList)];
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
        
        IRExplorerEntry *currentEntry = (_explorerEntryType == SUBJECT || _explorerEntryType == COURSE) ?
            [[indexedEntries objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] : [entries objectAtIndex:indexPath.row];
        cell.textLabel.text = [[currentEntry title] isEqual: @""] ? @"Default" : [currentEntry title];
        cell.detailTextLabel.text = [currentEntry subtitle];
        [cell.textLabel setNeedsDisplay];
        [cell.detailTextLabel setNeedsDisplay];
        if ([currentEntry type] != SECTION) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"CRN: %@, Status: %@", cell.detailTextLabel.text, ((IRExplorerSectionEntry *)currentEntry).enrollmentStatus];
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
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
            if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark) {
                if (selectedEntries != nil) {
                    [selectedEntries removeObject:currentSelectedEntry];
                }
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            } else {
                if (selectedEntries == nil) {
                    selectedEntries = [[NSMutableArray alloc] init];
                }
                [selectedEntries addObject:currentSelectedEntry];
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            }
        } else {
            //_subLayerExplorerViewController = [[ExplorerViewController alloc] initWithExplorerEntryType:[currentSelectedEntry type] + 1];
            _subLayerExplorerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"explorer"];
            _subLayerExplorerViewController.explorerEntryType = [currentSelectedEntry type] + 1;
            _subLayerExplorerViewController.title = currentSelectedEntry.title;
            _subLayerExplorerViewController.explorerURL = currentSelectedEntry.subLayerURL;
            [_subLayerExplorerViewController loadDataToTableView];
            
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
        [self displayActivityView];
    }
    [AppDelegate downloadDataFromURL:_explorerURL withCompletionHandler:^(NSData *xmlData) {
        if (xmlData != nil) {
            NSLog(@"Received XML Data.");
            RXMLElement *xmlElement = [RXMLElement elementFromXMLData:xmlData];
            NSMutableArray *currentEntries = [[NSMutableArray alloc] init];
            IRExplorerEntryType listEntryType = [IRExplorerEntry xmlTagToType:xmlElement.tag] + 1;
            
            [xmlElement iterate:[[[IRExplorerEntry typeToXMLTag:listEntryType plural:YES] stringByAppendingString:@"."] stringByAppendingString:[IRExplorerEntry typeToXMLTag:listEntryType plural:NO]] usingBlock: ^(RXMLElement *entry) {
                if (listEntryType == SECTION) {
                    IRExplorerSectionEntry *currentSectionEntry = [[IRExplorerSectionEntry alloc] initWithXMLID:[entry attribute:@"id"] text:entry.text href:[entry attribute:@"href"] type:entry.tag];
                    NSURLRequest *currentSectionURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[entry attribute:@"href"]]];
                    NSURLResponse *response = nil;
                    NSError *error = nil;
                    NSData *sectionXMLData = [NSURLConnection sendSynchronousRequest:currentSectionURLRequest returningResponse:&response error:&error];
                    if (sectionXMLData != nil) {
                        RXMLElement *sectionXMLElement = [RXMLElement elementFromXMLData:sectionXMLData];
                        currentSectionEntry.statusCode = [sectionXMLElement child:@"statusCode"].text;
                        currentSectionEntry.partOfTerm = [sectionXMLElement child:@"partOfTerm"].text;
                        currentSectionEntry.sectionStatusCode = [sectionXMLElement child:@"sectionStatusCode"].text;
                        currentSectionEntry.enrollmentStatus = [sectionXMLElement child:@"enrollmentStatus"].text;
                        currentSectionEntry.startDate = [sectionXMLElement child:@"startDate"].text;
                        currentSectionEntry.endDate = [sectionXMLElement child:@"endDate"].text;
                    }
                    [currentEntries addObject:currentSectionEntry];
                } else {
                    IRExplorerEntry *currentEntry = [[IRExplorerEntry alloc] initWithXMLID:[entry attribute:@"id"] text:entry.text href:[entry attribute:@"href"] type:entry.tag];
                    [currentEntries addObject:currentEntry];
                }
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


#pragma mark - Add to Wishlist

- (void)addSectionsToWishList {
    for (IRExplorerEntry *currentSelectedEntry in selectedEntries) {
        NSLog(@"Selected: %@", [currentSelectedEntry title]);
    }
    WishListViewController *wishListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"wishList"];
    [self.navigationController pushViewController:wishListViewController animated:YES];
    //[self.navigationController presentViewController:wishListViewController animated:YES completion:nil];
    
//    [self displayActivityView];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSDictionary *parameters = @{@"foo": @"bar"};
//    [manager POST:@"http://example.com/resources.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//        [self removeActivityView];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        [self removeActivityView];
//    }];
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
