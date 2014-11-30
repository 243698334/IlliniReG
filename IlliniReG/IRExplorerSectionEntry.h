//
//  IRExplorerSectionItem.h
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/19/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRExplorerEntry.h"

@interface IRExplorerSectionEntry : IRExplorerEntry

@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *semester;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *course;
@property (nonatomic, copy) NSString *section;

@property (nonatomic, copy) NSString *statusCode;
@property (nonatomic, copy) NSString *partOfTerm;
@property (nonatomic, copy) NSString *sectionStatusCode;
@property (nonatomic, copy) NSString *enrollmentStatus;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, copy) NSArray *meetings;

- (id)initWithExplorerEntry:(IRExplorerEntry *)explorerEntry;

@end
