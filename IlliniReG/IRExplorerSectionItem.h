//
//  IRExplorerSectionItem.h
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/19/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IRExplorerSectionItem : NSObject

@property (nonatomic, copy) NSString *semester;
@property (nonatomic, copy) NSString *subjectFullDescription;
@property (nonatomic, copy) NSString *subjectAbbreviation;
@property (nonatomic, copy) NSString *courseFullDescription;
@property (nonatomic, copy) NSString *courseNumber;
@property (nonatomic, copy) NSString *section;

@end
