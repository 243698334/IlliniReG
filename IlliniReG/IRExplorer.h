//
//  IRExplorer.h
//  IlliniReG
//
//  Created by Kevin Yufei Chen on 11/27/14.
//  Copyright (c) 2014 Kevin Yufei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RaptureXML/RXMLElement.h>
#import "IRExplorerEntry.h"
#import "IRExplorerSectionEntry.h"

@interface IRExplorer : NSObject

extern NSString * const CISAppAPIBaseURL;

+ (NSURL *)constructURLWithWithYear:(NSString *)year semester:(NSString *)semester subject:(NSString *)subject course:(NSString *)course section:(NSString *)section;
@end
