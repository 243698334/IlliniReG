//
//  IRExplorer.h
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/27/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRExplorerListEntry.h"
#import "IRExplorerSectionItem.h"

@interface IRExplorer : NSObject <NSXMLParserDelegate> {
    NSArray *retrievedList;
    NSArray *lastRetrievedList;
}

extern NSString * const CISAPPAPIURL;

- (NSArray *)retrieveLastList;
- (NSArray *)retrieveList;
- (NSArray *)retrieveListWithYear:(NSString *)year;
- (NSArray *)retrieveListWithYear:(NSString *)year semester:(NSString *)semester;
- (NSArray *)retrieveListWithYear:(NSString *)year semester:(NSString *)semester subject:(NSString *)subject;
- (NSArray *)retrieveListWithYear:(NSString *)year semester:(NSString *)semester subject:(NSString *)subject course:(NSString *)course;
- (NSArray *)retrieveItemWithYear:(NSString *)year semester:(NSString *)semester subject:(NSString *)subject course:(NSString *)course section:(NSString *)section;

@end
