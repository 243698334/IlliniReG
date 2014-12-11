//
//  IRm
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 12/1/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import "IRMonitor.h"

@implementation IRMonitor

// NSString * const MonitorAPI = @"https://illinireg.kevinychen.com/api/monitor";
NSString * const MonitorAPI = @"http://localhost:3000/api/v1/ir_monitor_data/";

NSString * const kMonitorIDKey = @"monitor";
NSString * const kNetIDKey = @"netID";
NSString * const kStatusKey = @"status";
NSString * const kAutoRegisterKey = @"autoRegister";
NSString * const kNameKey = @"name";
NSString * const kRefreshFrequencyKey = @"refreshFrequency";
NSString * const kUserAgentTypeKey = @"userAgentType";
NSString * const kUserAgentContentKey = @"userAgentContent";
NSString * const kPushNotificationKey = @"pushNotification";
NSString * const kSMSNumberKey = @"smsNumber";
NSString * const kEmailKey = @"email";
NSString * const kSectionEntriesKey = @"sectionEntries";

+ (IRMonitorStatus)stringToStatus:(NSString *)statusString {
    if ([statusString isEqualToString:@"ON"]) {
        return ON;
    } else if ([statusString isEqualToString:@"OFF"]) {
        return OFF;
    } else if ([statusString isEqualToString:@"SUCCESS"]) {
        return SUCCESS;
    }
    return -1;
}

+ (NSString *)statusToString:(IRMonitorStatus)status {
    switch (status) {
        case ON:
            return @"ON";
        case OFF:
            return @"OFF";
        case SUCCESS:
            return @"SUCCESS";
        default:
            return nil;
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _name = [aDecoder decodeObjectForKey:kNameKey];
        _monitorID = [aDecoder decodeObjectForKey:kMonitorIDKey];
        _netID = [aDecoder decodeObjectForKey:kNetIDKey];
        _status = [aDecoder decodeIntForKey:kStatusKey];
        _autoRegister = [aDecoder decodeBoolForKey:kAutoRegisterKey];
        _refreshFrequency = [aDecoder decodeObjectForKey:kRefreshFrequencyKey];
        _userAgentType = [aDecoder decodeObjectForKey:kUserAgentTypeKey];
        _userAgentContent = [aDecoder decodeObjectForKey:kUserAgentContentKey];
        _pushNotification = [aDecoder decodeBoolForKey:kPushNotificationKey];
        _smsNumber = [aDecoder decodeObjectForKey:kSMSNumberKey];
        _email = [aDecoder decodeObjectForKey:kEmailKey];
        _sectionEntries = [aDecoder decodeObjectForKey:kSectionEntriesKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:kNameKey];
    [aCoder encodeObject:_monitorID forKey:kMonitorIDKey];
    [aCoder encodeObject:_netID forKey:kNetIDKey];
    [aCoder encodeInt:_status forKey:kStatusKey];
    [aCoder encodeBool:_autoRegister forKey:kAutoRegisterKey];
    [aCoder encodeObject:_refreshFrequency forKey:kRefreshFrequencyKey];
    [aCoder encodeObject:_userAgentType forKey:kUserAgentTypeKey];
    [aCoder encodeObject:_userAgentContent forKey:kUserAgentContentKey];
    [aCoder encodeBool:_pushNotification forKey:kPushNotificationKey];
    [aCoder encodeObject:_smsNumber forKey:kSMSNumberKey];
    [aCoder encodeObject:_email forKey:kEmailKey];
    [aCoder encodeObject:_sectionEntries forKey:kSectionEntriesKey];
}

@end
