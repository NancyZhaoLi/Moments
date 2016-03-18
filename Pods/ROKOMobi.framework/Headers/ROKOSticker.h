//
//  ROKOSticker.h
//  ROKOStickers
//
//  Created by Alexey Golovenkov on 14.05.15.
//  Copyright (c) 2015 ROKOLabs. All rights reserved.
//

#import "ROKOImageDataObject.h"

/// @name ROKOStickers

/**
 *  Represents Sticekr object
 */
@interface ROKOSticker : ROKODataObject

/**
 *  Default scale that should be used when the sticker appears on screen
 */
@property (nonatomic, assign) float scaleFactor;

/**
 *  Stores information about sticker image
 */
@property (nonatomic, strong) ROKOImageDataObject *imageInfo;

@end
