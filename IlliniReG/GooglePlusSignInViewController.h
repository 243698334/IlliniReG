//
//  GooglePlusSignInViewController.h
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 12/4/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>

static NSString * const kClientID;

@class GPPSignInButton;

@interface GooglePlusSignInViewController : UIViewController <GPPSignInDelegate>

@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;

@end
