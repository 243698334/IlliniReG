//
//  HomeViewController.m
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/17/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import "HomeViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)awakeFromNib {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GooglePlusSignInViewController *googlePlusSignInViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GooglePlusSignIn"];
    [self presentViewController:googlePlusSignInViewController animated:YES completion:^{
        [self loadProfile];
    }];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:110.0/255.0 green:139.0/255.0 blue:191.0/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTranslucent:NO];
}

- (void)loadProfile {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
