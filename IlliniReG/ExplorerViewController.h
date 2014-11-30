//
//  ExplorerTableViewController.h
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/17/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "IRExplorer.h"

@interface ExplorerViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate, UIAlertViewDelegate, UINavigationBarDelegate>

- (instancetype)init;
- (instancetype)initWithYear:(NSString *)year semester:(NSString *)semester subject:(NSString *)subject course:(NSString *)course;

@property (nonatomic, strong) NSString *currentYear;
@property (nonatomic, strong) NSString *currentSemester;
@property (nonatomic, strong) NSString *currentSubject;
@property (nonatomic, strong) NSString *currentCourse;
@property (nonatomic, strong) NSString *currentSection;
@property (nonatomic, strong) NSString *currentTableCellID;
@property (nonatomic, strong) NSURL *currentExplorerURL;

@end
