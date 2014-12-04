//
//  ExplorerTableViewController.h
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/17/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DejalActivityView/DejalActivityView.h>
#import <AFNetworking/AFNetworking.h>
#import <RMMapper/NSUserDefaults+RMSaveCustomObject.h>
#import "WishListViewController.h"
#import "IRExplorer.h"
#import "IRSectionEntry.h"

@interface ExplorerViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate, UISearchResultsUpdating, UIAlertViewDelegate, UINavigationBarDelegate>

@property (nonatomic) IRExplorerEntryType explorerEntryType;
@property (nonatomic, strong) NSURL *explorerURL;
@property (nonatomic, strong) ExplorerViewController *subLayerExplorerViewController;

@end
