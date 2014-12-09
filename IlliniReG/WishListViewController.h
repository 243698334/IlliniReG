//
//  WishListViewController.h
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/30/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JMStaticContentTableViewController/JMStaticContentTableViewController.h>
#import "IRWishList.h"

@interface WishListViewController : JMStaticContentTableViewController <UIAlertViewDelegate>

@property (nonatomic, copy) IRWishList *wishList;

@end
