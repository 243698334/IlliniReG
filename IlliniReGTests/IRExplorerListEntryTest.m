//
//  IRExplorerEntryTest.m
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/19/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "IRExplorerListEntry.h"

@interface IRExplorerListEntryTest : XCTestCase {
    IRExplorerListEntry *entry;
}

@end

@implementation IRExplorerListEntryTest

- (void)setUp {
    [super setUp];
    entry = [[IRExplorerListEntry alloc] initWithXMLID:@"125" text:@"Intro to Computer Science" href:@"http://courses.illinois.edu/cisapp/explorer/schedule/2015/spring/CS/125.xml" type:@"course"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExplorerEntryType {
    XCTAssertEqual(COURSE, [entry type]);
}

- (void)testTitle {
    XCTAssertEqual(@"125", [entry title]);
}

- (void)testSubtitle {
    XCTAssertEqual(@"Intro to Computer Science", [entry subtitle]);
}

- (void)testNextLayerURL {
    XCTAssertEqual(@"http://courses.illinois.edu/cisapp/explorer/schedule/2015/spring/CS/125.xml", [[entry subLayerURL] absoluteString]);
}

@end
