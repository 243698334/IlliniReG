//
//  IRExplorer.m
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/18/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import "IRExplorer.h"

static NSString *CISAppAPIURL = @"http://courses.illinois.edu/cisapp/explorer/schedule.xml";

@implementation IRExplorer

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
    lastRetrievedList = [retrievedList copy];
    NSURL *retrieveListURL = [self constructURLWithWithYear:year semester:semester subject:subject course:course section:nil];
    AFRaptureXMLRequestOperation *retrieveListOperation =
        [AFRaptureXMLRequestOperation XMLParserRequestOperationWithRequest:[NSURLRequest requestWithURL:retrieveListURL]
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, RXMLElement *xmlElement) {
            retrievedList = [self parseXMLElementForList:xmlElement];
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, RXMLElement *xmlElement) {
            retrievedList = nil;
        }];
    [retrieveListOperation start];
    return retrievedList;
}

- (NSArray *)retrieveLastList {
    return lastRetrievedList;
}

- (IRExplorerSectionItem *)retrieveItemWithYear:(NSString *)year semester:(NSString *)semester subject:(NSString *)subject course:(NSString *)course section:(NSString *)section {
    return nil;
}

- (NSURL *)constructURLWithWithYear:(NSString *)year semester:(NSString *)semester subject:(NSString *)subject course:(NSString *)course section:(NSString *)section {
    NSMutableString *requestedURL = [[NSMutableString alloc] initWithString:CISAppAPIURL];
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

- (NSArray *)parseXMLElementForList:(RXMLElement *)xmlElement {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    IRExplorerListEntryType listEntryType = [IRExplorerListEntry xmlTagToType:xmlElement.tag] + 1;
    [xmlElement iterate:[IRExplorerListEntry typeToXMLTag:listEntryType plural:YES] usingBlock: ^(RXMLElement *entry) {
        IRExplorerListEntry *currentEntry = [[IRExplorerListEntry alloc] initWithXMLID:[entry attribute:@"id"] text:entry.text href:[entry attribute:@"href"] type:[IRExplorerListEntry typeToXMLTag:listEntryType plural:NO]];
        [list addObject:currentEntry];
    }];
    return list;
}

- (IRExplorerSectionItem *)parseXMLElementForItem:(RXMLElement *)xmlElement {
    return nil;
}

@end
