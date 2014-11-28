//
//  IRExplorerTest.m
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/19/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "IRExplorerOld.h"

@interface IRExplorerTest : XCTestCase {
    IRExplorerOld *explorer;
}

@end

@implementation IRExplorerTest

- (void)setUp {
    [super setUp];
    explorer = [[IRExplorerOld alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testYearList {
    NSArray *yearList = [explorer retrieveList];
    XCTAssertEqual(12, [yearList count]);
}

- (void)testSemesterList {
    
}

- (void)testSubjectList {
    
}

- (void)testCourseList {
    
}

- (void)testSectionList {
    
}

@end
