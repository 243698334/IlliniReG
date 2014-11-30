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
    if (self = [self init]) {
        IRExplorerListEntryType currentType = [IRExplorerListEntry xmlTagToType:type];
        self.xmlID = xmlID;
        self.xmlText = text;
        switch (currentType) {
            case YEAR:
                [self setType:currentType title:xmlID subtitle:nil subLayerURL:[[NSURL alloc] initWithString:href]];
                break;
            case SEMESTER:
                [self setType:currentType title:text subtitle:nil subLayerURL:[[NSURL alloc] initWithString:href]];
                break;
            case SUBJECT:
                [self setType:currentType title:xmlID subtitle:text subLayerURL:[[NSURL alloc] initWithString:href]];
                break;
            case COURSE:
                [self setType:currentType title:xmlID subtitle:text subLayerURL:[[NSURL alloc] initWithString:href]];
                break;
            case SECTION:
                [self setType:currentType title:text subtitle:xmlID subLayerURL:[[NSURL alloc] initWithString:href]];
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)setType:(IRExplorerListEntryType)type title:(NSString *)title subtitle:(NSString *)subtitle subLayerURL:(NSURL *)subLayerURL {
    self.type = type;
    self.title = title;
    self.subtitle = subtitle;
    self.subLayerURL = subLayerURL;
}

@end
