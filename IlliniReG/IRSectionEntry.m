//
//  IRSectionEntry.m
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 12/4/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import "IRSectionEntry.h"


@implementation IRSectionEntry

NSString * const kYearKey = @"year";
NSString * const kSemesterKey = @"semester";
NSString * const kSubjectKey = @"subject";
NSString * const kCourseKey = @"course";
NSString * const kSectionKey = @"section";
NSString * const kCRNKey = @"crn";
NSString * const kStatusCodeKey = @"statusCode";
NSString * const kPartOfTermKey = @"partOfTerm";
NSString * const kSectionStatusCodeKey = @"sectionStatusCode";
NSString * const kEnrollmentStatusKey = @"enrollmentStatus";
NSString * const kStartDateKey = @"startDate";
NSString * const kEndDateKey = @"endDate";

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _year = [aDecoder decodeObjectForKey:kYearKey];
        _semester = [aDecoder decodeObjectForKey:kSemesterKey];
        _subject = [aDecoder decodeObjectForKey:kSubjectKey];
        _course = [aDecoder decodeObjectForKey:kCourseKey];
        _section = [aDecoder decodeObjectForKey:kSectionKey];
        _crn = [aDecoder decodeObjectForKey:kCRNKey];
        _statusCode = [aDecoder decodeObjectForKey:kStatusCodeKey];
        _partOfTerm = [aDecoder decodeObjectForKey:kPartOfTermKey];
        _sectionStatusCode = [aDecoder decodeObjectForKey:kSectionStatusCodeKey];
        _enrollmentStatus = [aDecoder decodeObjectForKey:kEnrollmentStatusKey];
        _startDate = [aDecoder decodeObjectForKey:kStartDateKey];
        _endDate = [aDecoder decodeObjectForKey:kEndDateKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_year forKey:kYearKey];
    [aCoder encodeObject:_semester forKey:kSemesterKey];
    [aCoder encodeObject:_subject forKey:kSubjectKey];
    [aCoder encodeObject:_course forKey:kCourseKey];
    [aCoder encodeObject:_section forKey:kSectionKey];
    [aCoder encodeObject:_crn forKey:kCRNKey];
    [aCoder encodeObject:_statusCode forKey:kStatusCodeKey];
    [aCoder encodeObject:_partOfTerm forKey:kPartOfTermKey];
    [aCoder encodeObject:_sectionStatusCode forKey:kSectionStatusCodeKey];
    [aCoder encodeObject:_enrollmentStatus forKey:kEnrollmentStatusKey];
    [aCoder encodeObject:_startDate forKey:kStartDateKey];
    [aCoder encodeObject:_endDate forKey:kEndDateKey];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[IRSectionEntry class]]) {
        IRSectionEntry *otherSectionEntry = (IRSectionEntry *)object;
        return [otherSectionEntry.year isEqualToString:_year] && [otherSectionEntry.semester isEqualToString:_semester]
        && [otherSectionEntry.subject isEqualToString:_subject] && [otherSectionEntry.course isEqualToString:_course]
        && [otherSectionEntry.crn isEqualToString:_crn] && [otherSectionEntry.statusCode isEqualToString:_statusCode]
        && [otherSectionEntry.partOfTerm isEqualToString:_partOfTerm] && [otherSectionEntry.sectionStatusCode isEqualToString:_sectionStatusCode]
        && [otherSectionEntry.enrollmentStatus isEqualToString:_enrollmentStatus] && [otherSectionEntry.startDate isEqualToString:_startDate]
        && [otherSectionEntry.endDate isEqualToString:_endDate];
    }
    return NO;
}

@end


