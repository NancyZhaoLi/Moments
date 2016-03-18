//
//  RLPhotoComposerDelegate.h
//  ROKOStickers
//
//  Created by Katerina Vinogradnaya on 22.04.14.
//  Copyright (c) 2014 ROKOLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RLStickerInfo;
@class RLPhotoComposerController;

@protocol RLPhotoComposerDelegate <NSObject>
@optional

- (void)composer:(RLPhotoComposerController *)composer didFinishWithPhoto:(UIImage *)photo;

- (void)composerDidCancel:(RLPhotoComposerController *)composer;

/**
 *  Called on viewWillAppear for Composer view controller. Can be used, for example, to customize UI
 *
 *  @param composer composer object to be shown
 *  @param animated YES if the composer will appear with animation
 */
- (void)composer:(RLPhotoComposerController *)composer willAppearAnimated:(BOOL)animated;

/**
 *  Called on viewWillAppear for Share view controller. Can be used, for example, to customize UI
 *
 *  @param controller   Controller to be customized
 *  @param animated		YES if the composer will appear with animation
 */
- (void)shareController:(RLPhotoComposerController *)controller willAppearAnimated:(BOOL)animated;

/**
 *  Calls when user pressed shared button
 *
 *  @param composer Composer object
 *  @param image    Images to be shared
 */
- (void)composer:(RLPhotoComposerController *)composer didPressShareButtonForImage:(UIImage *)image;

/**
 *  Informs delegate about adding a new sticker on composer screen
 *
 *  @param composer    Composer object
 *  @param stickerInfo Sticker that has been added
 */
- (void)composer:(RLPhotoComposerController *)composer didAddSticker:(RLStickerInfo *)stickerInfo;

/**
 *  Informs delegate about switching to StickersPack with index
 *
 *  @param composer Composer object
 *  @param packIndex    Index of StickerPack
 */
- (void)composer:(RLPhotoComposerController *)composer didSwitchToStickerPackAtIndex:(NSInteger)packIndex;

/**
 *  Informs delegate that sticker has been removed from composer screen
 *
 *  @param composer    Composer object
 *  @param stickerInfo Sticker that has been removed
 */
- (void)composer:(RLPhotoComposerController *)composer didRemoveSticker:(RLStickerInfo *)stickerInfo;

@end
