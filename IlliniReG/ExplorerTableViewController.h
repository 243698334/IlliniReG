//
//  ExplorerTableViewController.h
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/17/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExplorerTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate, UIAlertViewDelegate>

@property (nonatomic, strong, readonly) NSString *currentExplorerLayer;
@property (nonatomic, strong, readwrite) NSMutableArray *currentEntries;

@property (nonatomic, strong, readonly) UIProgressView *loadingProgressView;
@property (nonatomic, assign) BOOL shouldDisplaySearchBar;


@end
