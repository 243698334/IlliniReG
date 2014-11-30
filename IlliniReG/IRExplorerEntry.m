//
//  IRExplorerEntry.m
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/18/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import "IRExplorerEntry.h"

@implementation IRExplorerEntry

+ (NSString *)typeToXMLTag:(IRExplorerEntryType)type plural:(BOOL)isPlural {
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

+ (IRExplorerEntryType)xmlTagToType:(NSString *)xmlTag {
    if ([xmlTag hasPrefix:@"schedule"]) {
        return SCHEDULE;
    } else if ([xmlTag hasPrefix:@"calendarYear"]) {
        return YEAR;
    } else if ([xmlTag hasPrefix:@"term"]) {
        return SEMESTER;
    } else if ([xmlTag hasPrefix:@"subject"]) {
        return SUBJECT;
    } else if ([xmlTag hasPrefix:@"course"]) {
        return COURSE;
    } else if ([xmlTag hasPrefix:@"section"]) {
        return SECTION;
    }
    return -1;
}

- (instancetype)initWithXMLID:(NSString *)xmlID text:(NSString *)text href:(NSString *)href type:(NSString *)type {
    if (self = [self init]) {
        IRExplorerEntryType currentType = [IRExplorerEntry xmlTagToType:type];
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

- (void)setType:(IRExplorerEntryType)type title:(NSString *)title subtitle:(NSString *)subtitle subLayerURL:(NSURL *)subLayerURL {
    self.type = type;
    self.title = title;
    self.subtitle = subtitle;
    self.subLayerURL = subLayerURL;
}

@end
