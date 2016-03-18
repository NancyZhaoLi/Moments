//
//  RLStickerPackInfo.h
//  ROKOStickers
//
//  Created by Katerina Vinogradnaya on 6/21/14.
//  Copyright (c) 2014 ROKOLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "RLWatermarkInfo.h"

@interface RLStickerPackInfo : NSObject
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *packDescription;
@property (copy, nonatomic) NSString *iconDefaultURL;
@property (copy, nonatomic) NSString *iconSelectedURL;
@property (copy, nonatomic) UIImage *iconDefault;
@property (copy, nonatomic) UIImage *iconSelected;
@property (copy, nonatomic) NSArray *stickers;
@property (strong, nonatomic) RLWatermarkInfo *watermarkInfo;
@property (assign, nonatomic) BOOL isLocked;
@property (assign, nonatomic) BOOL isActive;
@property (assign, nonatomic) NSInteger packID;

@end
