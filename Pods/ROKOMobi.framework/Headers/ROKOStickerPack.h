//
//  ROKOStickerPack.h
//  ROKOStickers
//
//  Created by Alexey Golovenkov on 12.05.15.
//  Copyright (c) 2015 ROKOLabs. All rights reserved.
//

#import "ROKODataObject.h"
#import "ROKOStickersWatermarkInfo.h"


/// @name ROKOStickers

@interface ROKOStickerPack : ROKODataObject

@property (nonatomic, strong) ROKOImageDataObject *selectedIcon;
@property (nonatomic, strong) ROKOImageDataObject *unselectedIcon;
@property (nonatomic, assign) BOOL useWatermark;
@property (nonatomic, assign) BOOL useApplicationWatermark;
@property (nonatomic, assign) float watermarkScaleFactor;
@property (nonatomic, assign) NSInteger watermarkPosition;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *stickers;
@property (nonatomic, strong) ROKOStickersWatermarkInfo *watermark;
@property (nonatomic, assign) BOOL isActive;

@end
