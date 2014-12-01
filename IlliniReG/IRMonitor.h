//
//  IRMonitor.h
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 12/1/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ON = 0,
    OFF = 1,
    SUCCESS = 2
} IRMonitorStatus;

@interface IRMonitor : NSObject

@property (nonatomic) IRMonitorStatus status;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSMutableArray *entries;

@end
