//
//  ROKOFontDataObject.h
//  ROKOComponents
//
//  Created by Alexey Golovenkov on 07.05.15.
//  Copyright (c) 2015 ROKOLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ROKODataObject.h"

@interface ROKOFontDataObject : ROKODataObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *size;
@property (nonatomic, strong) UIColor *color;

- (UIFont *)font;

@end
