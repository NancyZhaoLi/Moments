//
//  RLPhotoComposerDataSource.h
//  ROKOStickers
//
//  Created by Katerina Vinogradnaya on 7/20/14.
//  Copyright (c) 2014 ROKOLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RLPhotoComposerController;
@class RLStickerPackInfo;
@class RLStickerInfo;
@class ROKOStickersWatermarkInfo;

@protocol RLPhotoComposerDataSource <NSObject>

- (NSInteger)numberOfStickerPacksInComposer:(RLPhotoComposerController *)composer;

- (NSInteger)numberOfStickersInPackAtIndex:(NSInteger)packIndex composer:(RLPhotoComposerController *)composer;

- (RLStickerPackInfo *)composer:(RLPhotoComposerController *)composer infoForStickerPackAtIndex:(NSInteger)packIndex;

- (RLStickerInfo *)composer:(RLPhotoComposerController *)composer infoForStickerAtIndex:(NSInteger)stickerIndex packIndex:(NSInteger)packIndex;

- (ROKOStickersWatermarkInfo *)composer:(RLPhotoComposerController *)composer watermarkInfoAtIndex:(NSInteger)packIndex;

@end
