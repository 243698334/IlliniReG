//
//  IRExplorerEntry.h
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/18/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SCHEDULE = 0,
    YEAR = 1,
    SEMESTER = 2,
    SUBJECT = 3,
    COURSE = 4,
    SECTION = 5,
    DETAIL = 6
} IRExplorerEntryType;

@interface IRExplorerEntry : NSObject

// title and subTitle can represent different information under different entry type.
//
//    type   |    title     |     subTitle
// ----------|--------------|------------------
//    year   |    year      |
//  semester |   semester   |
//  subject  | abbreviation | full description
//   course  |    number    | full description
//  section  |   section    | CRN, instructor
//

@property (nonatomic) IRExplorerEntryType type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSURL *subLayerURL;

@property (nonatomic, copy) NSString *xmlID;
@property (nonatomic, copy) NSString *xmlText;

+ (NSString *)typeToXMLTag:(IRExplorerEntryType)type plural:(BOOL)isPlural;
+ (IRExplorerEntryType)xmlTagToType:(NSString *)xmlTag;

- (instancetype)initWithXMLID:(NSString *)xmlID text:(NSString *)text href:(NSString *)href type:(NSString *)type;

@end
