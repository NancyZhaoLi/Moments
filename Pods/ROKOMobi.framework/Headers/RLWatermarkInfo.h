//
//  RLWatermarkInfo.h
//  ROKOStickers
//
//  Created by Katerina Vinogradnaya on 7/3/14.
//  Copyright (c) 2014 ROKOLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ROKOStickersWatermarkInfo.h"

typedef NS_ENUM (NSInteger, RLWatermarkPosition) {
	kRLWatermarkPositionTopLeft = 1,
	kRLWatermarkPositionTop,
	kRLWatermarkPositionTopRight,
	kRLWatermarkPositionMiddleTopLeft,
	kRLWatermarkPositionMiddleTopCenter,
	kRLWatermarkPositionMiddleTopRight,
	kRLWatermarkPositionMiddleBottomLeft,
	kRLWatermarkPositionMiddleBottom,
	kRLWatermarkPositionMiddleBottomRight,
    kRLWatermarkPositionBottomLeft,
    kRLWatermarkPositionBottom,
    kRLWatermarkPositionBottomRight,
	kRLWatermarkPositionFullScreen
};

@interface RLWatermarkInfo : NSObject<NSCopying>
@property (copy, nonatomic) UIImage *icon;
@property (copy, nonatomic) NSString *iconURL;
@property (assign, nonatomic) RLWatermarkPosition position;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGFloat scale;

-(instancetype)initWithRokoStickersWatermarkInfo:(ROKOStickersWatermarkInfo*)rokoStickersWatermarkInfo;
@end
