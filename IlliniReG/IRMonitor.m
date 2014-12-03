//
//  IRm
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 12/1/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import "IRMonitor.h"

@implementation IRMonitor

- (id)init {
    if (self = [super init]) {
        _name = @"New Monitor";
        _autoRegister = NO;
        _refreshFrequency = 30;
        _userAgentType = @"Chrome";
        _pushNotification = YES;
        _smsNumber = @"(217) 419-5313";
        _email = nil;
    }
    return self;
}

@end
