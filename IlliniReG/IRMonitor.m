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


- (id)init {
    return [self initWithTestValues];
}

- (id)initWithTestValues {
    if (self = [super init]) {
        _monitorID = @99;
        _name = @"New Monitor";
        _autoRegister = NO;
        _refreshFrequency = @30;
        _userAgentType = @"Chrome";
        _pushNotification = YES;
        _smsNumber = @"(217) 419-5313";
        _email = nil;
    }
    return self;
}

@end
