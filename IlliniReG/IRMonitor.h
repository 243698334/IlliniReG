//
//  IRMonitor.h
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 12/1/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRMonitorEntry.h"

typedef enum {
    ON = 0,
    OFF = 1,
    SUCCESS = 2
} IRMonitorStatus;

@interface IRMonitor : NSObject

@property (nonatomic) IRMonitorStatus status;
@property (nonatomic) BOOL autoRegister;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSMutableArray *entries;
@property (nonatomic) NSInteger refreshFrequency;
@property (nonatomic, copy) NSString *userAgentContent;
@property (nonatomic, copy) NSString *userAgentType;
@property (nonatomic) BOOL pushNotification;
@property (nonatomic, copy) NSString *smsNumber;
@property (nonatomic, copy) NSString *email;

@end
