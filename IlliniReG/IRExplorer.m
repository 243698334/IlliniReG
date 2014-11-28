//
//  IRExplorer.m
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/27/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import "IRExplorer.h"

NSString * const CISAPPAPIURL = @"http://courses.illinois.edu/cisapp/explorer/schedule.xml";

@implementation IRExplorer

- (NSArray *)retrieveLastList {
    return lastRetrievedList;
}

- (NSArray *)retrieveList {
    return [self retrieveListWithYear:nil semester:nil subject:nil course:nil];
}

- (NSArray *)retrieveListWithYear:(NSString *)year {
    return [self retrieveListWithYear:year semester:nil subject:nil course:nil];
}
- (NSArray *)retrieveListWithYear:(NSString *)year semester:(NSString *)semester {
    return [self retrieveListWithYear:year semester:semester subject:nil course:nil];
}
- (NSArray *)retrieveListWithYear:(NSString *)year semester:(NSString *)semester subject:(NSString *)subject {
    return [self retrieveListWithYear:year semester:semester subject:subject course:nil];
}

- (NSArray *)retrieveListWithYear:(NSString *)year semester:(NSString *)semester subject:(NSString *)subject course:(NSString *)course {
    return nil;
}

- (IRExplorerSectionItem *)retrieveItemWithYear:(NSString *)year semester:(NSString *)semester subject:(NSString *)subject course:(NSString *)course section:(NSString *)section {
    return nil;
}

- (NSURL *)constructURLWithWithYear:(NSString *)year semester:(NSString *)semester subject:(NSString *)subject course:(NSString *)course section:(NSString *)section {
    NSMutableString *requestedURL = [[NSMutableString alloc] initWithString:CISAPPAPIURL];
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
    return [[NSURL alloc] initWithString:requestedURL];
}



@end
