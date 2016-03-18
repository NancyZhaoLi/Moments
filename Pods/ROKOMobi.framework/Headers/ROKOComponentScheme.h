//
//  ROKOComponentScheme.h
//  ROKOComponents
//
//  Created by Alexey Golovenkov on 17.04.15.
//  Copyright (c) 2015 ROKOLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ROKOImageDataObject.h"
#import "ROKOFontDataObject.h"

@interface ROKOComponentScheme : NSObject <NSCoding>

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (void)loadFromDictionary:(NSDictionary *)dictionary;

// Parsing helpers
- (UIColor *)decodeColorFromCoder:(NSCoder *)aDecoder forKey:(NSString *)key;
- (ROKODataObject *)dataObjectFromDictionary:(NSDictionary *)dictionary withKey:(NSString *)key;
- (ROKOFontDataObject *)fontDataObjectFromDictionary:(NSDictionary *)dictionary withKey:(NSString *)key;
- (UIColor *)colorFromDictionary:(NSDictionary *)dictionary withKey:(NSString *)key;

@end
