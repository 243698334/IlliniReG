//
//  IRExplorerEntry.m
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/18/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import "IRExplorerListEntry.h"

@implementation IRExplorerListEntry

+ (NSString *)typeToXMLTag:(IRExplorerListEntryType)type plural:(BOOL)isPlural {
    switch (type) {
        case YEAR:
            return isPlural ? @"calendarYears" : @"calendarYear";
        case SEMESTER:
            return isPlural ? @"terms" : @"term";
        case SUBJECT:
            return isPlural ? @"subjects" : @"subject";
        case COURSE:
            return isPlural ? @"courses" : @"course";
        case SECTION:
            return isPlural ? @"sections" : @"section";
        default:
            return nil;
    }
}

+ (IRExplorerListEntryType)xmlTagToType:(NSString *)xmlTag {
    IRExplorerListEntryType type;
    if ([xmlTag hasPrefix:@"schedule"]) {
        type = SCHEDULE;
    } else if ([xmlTag hasPrefix:@"calendarYear"]) {
        type = YEAR;
    } else if ([xmlTag hasPrefix:@"term"]) {
        type = SEMESTER;
    } else if ([xmlTag hasPrefix:@"subject"]) {
        type = SUBJECT;
    } else if ([xmlTag hasPrefix:@"course"]) {
        type = COURSE;
    } else if ([xmlTag hasPrefix:@"section"]) {
        type = SECTION;
    }
    return type;
}

- (instancetype)initWithXMLID:(NSString *)xmlID text:(NSString *)text href:(NSString *)href type:(NSString *)type {
    IRExplorerListEntryType currentType = [IRExplorerListEntry xmlTagToType:type];
    switch (currentType) {
        case YEAR:
            return [self initWithEntryType:currentType title:xmlID subtitle:nil nextLayerURL:[[NSURL alloc] initWithString:href]];
        case SEMESTER:
            return [self initWithEntryType:currentType title:text subtitle:nil nextLayerURL:[[NSURL alloc] initWithString:href]];
        case SUBJECT:
            return [self initWithEntryType:currentType title:xmlID subtitle:text nextLayerURL:[[NSURL alloc] initWithString:href]];
        case COURSE:
            return [self initWithEntryType:currentType title:xmlID subtitle:text nextLayerURL:[[NSURL alloc] initWithString:href]];
        case SECTION:
            return [self initWithEntryType:currentType title:text subtitle:xmlID nextLayerURL:[[NSURL alloc] initWithString:href]];
        default:
            return nil;
    }
}

- (instancetype)initWithEntryType:(IRExplorerListEntryType)type title:(NSString *)title subtitle:(NSString *)subTitle nextLayerURL:(NSURL *)nextLayerURL {
    if (self = [self init]) {
        self.type = type;
        self.title = title;
        self.subtitle = subTitle;
        self.nextLayerURL = nextLayerURL;
    }
    return self;
}

@end
