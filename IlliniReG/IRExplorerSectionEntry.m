//
//  IRExplorerSectionItem.m
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/19/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import "IRExplorerSectionEntry.h"

@implementation IRExplorerSectionEntry

- (id)initWithExplorerEntry:(IRExplorerEntry *)explorerEntry {
    if (self = [super init]) {
        self.type = explorerEntry.type;
        self.title = explorerEntry.title;
        self.subtitle = explorerEntry.subtitle;
        self.subLayerURL = explorerEntry.subLayerURL;
    }
    return self;
}


@end
