//
//  IRExplorerEntry.h
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/18/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SUBJECT, NUMBER, SECTION
} IRExplorerEntryType;

@interface IRExplorerEntry : NSObject

// title and subTitle can represent different information under different entry type.
//
//   type   |      title       |     subTitle
// ---------|------------------|------------------
//  subject | full description | abbreviation
//  number  |      number      | full description
//  section |     section      | instructors
//

@property (nonatomic) IRExplorerEntryType type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;

@end
