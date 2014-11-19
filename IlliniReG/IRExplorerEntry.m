//
//  IRExplorerEntry.m
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/18/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import "IRExplorerEntry.h"

@implementation IRExplorerEntry

- (id)initWithEntryType:(IRExplorerEntryType)type title:(NSString *)title subTitle:(NSString *)subTitle {
    self = [self init];
    self.type = type;
    self.title = title;
    self.subTitle = subTitle;
    return self;
}

@end
