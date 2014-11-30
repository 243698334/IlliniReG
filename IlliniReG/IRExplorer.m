//
//  IRExplorer.m
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/27/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import "IRExplorer.h"

@implementation IRExplorer

NSString * const CISAppAPIBaseURL = @"http://courses.illinois.edu/cisapp/explorer/schedule.xml";

+ (NSURL *)constructURLWithWithYear:(NSString *)year semester:(NSString *)semester subject:(NSString *)subject course:(NSString *)course section:(NSString *)section {
    NSMutableString *requestedURL = [[NSMutableString alloc] initWithString:CISAppAPIBaseURL];
    if (year != nil) {
        [requestedURL insertString:[@"/" stringByAppendingString:year] atIndex:[requestedURL rangeOfString:@".xml"].location];
    }
    if (semester != nil) {
        [requestedURL insertString:[@"/" stringByAppendingString:semester] atIndex:[requestedURL rangeOfString:@".xml"].location];
    }
    if (subject != nil) {
        [requestedURL insertString:[@"/" stringByAppendingString:subject] atIndex:[requestedURL rangeOfString:@".xml"].location];
    }
    if (course != nil) {
        [requestedURL insertString:[@"/" stringByAppendingString:course] atIndex:[requestedURL rangeOfString:@".xml"].location];
    }
    if (section != nil) {
        [requestedURL insertString:[@"/" stringByAppendingString:section] atIndex:[requestedURL rangeOfString:@".xml"].location];
    }
    NSLog(@"Constructed URL: %@", requestedURL);
    return [[NSURL alloc] initWithString:requestedURL];
}

@end
