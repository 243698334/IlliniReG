//
//  GooglePlusSignInViewController.m
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 12/4/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import "GooglePlusSignInViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface GooglePlusSignInViewController ()

@end

@implementation GooglePlusSignInViewController

static NSString * const kClientID = @"627137987994-mc20jp5m3eojp2mm07oju982cs89n5e8.apps.googleusercontent.com";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithRed:110.0/255.0 green:139.0/255.0 blue:191.0/255.0 alpha:1.0]];
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = kClientID;
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    //signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
    signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
    
    _signInButton.colorScheme = kGPPSignInButtonColorSchemeDark;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GPPSignInDelegate

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@",error, auth);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentSignInViewController:(UIViewController *)viewController {
    // This is an example of how you can implement it if your app is navigation-based.
    [[self navigationController] pushViewController:viewController animated:YES];
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
