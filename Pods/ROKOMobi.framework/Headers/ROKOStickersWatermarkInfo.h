//
//  ROKOStickersWatermarkInfo.h
//  ROKOStickers
//
//  Created by Alexey Golovenkov on 21.04.15.
//  Copyright (c) 2015 ROKOLabs. All rights reserved.
//

#import "ROKOImageDataObject.h"

typedef NS_ENUM (NSInteger, ROKOStickersWatermarkPosition) {
	ROKOStickersWatermarkPositionTopLeft = 1,
	ROKOStickersWatermarkPositionTop,
	ROKOStickersWatermarkPositionTopRight,
	ROKOStickersWatermarkPositionMiddleTopLeft,
	ROKOStickersWatermarkPositionMiddleTopCenter,
	ROKOStickersWatermarkPositionMiddleTopRight,
	ROKOStickersWatermarkPositionMiddleBottomLeft,
	ROKOStickersWatermarkPositionMiddleBottom,
	ROKOStickersWatermarkPositionMiddleBottomRight,
	ROKOStickersWatermarkPositionBottomLeft,
	ROKOStickersWatermarkPositionBottom,
	ROKOStickersWatermarkPositionBottomRight,
	ROKOStickersWatermarkPositionFullScreen
};


@interface ROKOStickersWatermarkInfo : ROKODataObject

@property (nonatomic, assign) BOOL isApplicationDefault;
@property (nonatomic, assign) NSInteger position;
@property (nonatomic, assign) float scale;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *watermarkDescription;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSDate *updateDate;
@property (nonatomic, strong) ROKOImageDataObject *imageData;

@end
