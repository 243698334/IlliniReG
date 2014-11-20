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
    entry = [[IRExplorerListEntry alloc] initWithEntryType:@"subject"
                                                     title:@"Computer Science"
                                                  subtitle:@"CS"
                                              nextLayerURL:@"http://courses.illinois.edu/cisapp/explorer/schedule/2015/spring/CS.xml"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExplorerEntryType {
    XCTAssertEqual(SUBJECT, [entry type]);
}

- (void)testTitle {
    XCTAssertEqual(@"Computer Science", [entry title]);
}

- (void)testSubtitle {
    XCTAssertEqual(@"CS", [entry subtitle]);
}

- (void)testNextLayerURL {
    XCTAssertEqual(@"http://courses.illinois.edu/cisapp/explorer/schedule/2015/spring/CS.xml", [[entry nextLayerURL] absoluteString]);
}

@end
