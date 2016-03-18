//
//  ROKOServerStatus.h
//  ROKOMobi
//
//  Created by Maslov Sergey on 26.08.15.
//  Copyright (c) 2015 ROKO Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROKOComponent.h"

@interface ROKOServerStatus : NSObject
+ (NSString *)statusCodeToString:(ROKOStatusCode)statusCode;
+ (ROKOStatusCode)stringToStatusCode:(NSString *)strVal;
@end
