//
//  RLPhotoComposerController.h
//  ROKOStickers
//
//  Created by Katerina Vinogradnaya on 22.04.14.
//  Copyright (c) 2014 ROKOLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ROKOComponentCustomizer.h"
#import "RLPhotoComposerDelegate.h"
#import "RLPhotoComposerDataSource.h"
#import "RLWatermarkInfo.h"

typedef NS_ENUM (NSInteger, RLPackButtonMode) {
	RLPackButtonModeRectangle,
	RLPackButtonModeEllipse
};

@interface RLPhotoComposerController : UIViewController

// delegate & datasource
@property (weak, nonatomic) id <RLPhotoComposerDelegate> delegate;
@property (weak, nonatomic) id <RLPhotoComposerDataSource> dataSource;

@property (strong, nonatomic, readonly) ROKOComponentCustomizer *customizer;
@property (nonatomic, strong) NSUUID *photoId;

@property (strong, nonatomic) UIImage *photo;


@property (nonatomic, strong) ROKOComponentScheme *scheme;

// customizable properties
@property (copy, nonatomic) NSString *photoAlbumName;
@property (assign, nonatomic) BOOL displayStickerPacksTitles;
@property (assign, nonatomic) BOOL savePhotosToCameraRoll;
@property (assign, nonatomic) BOOL enablePhotoSharing;
@property (nonatomic, strong) UIColor *packsBarColor;
@property (nonatomic, strong) UIColor *iconsBarColor;
@property (nonatomic, strong) UIColor *packButtonColor;
@property (nonatomic, strong) UIColor *packButtonSelectedColor;
@property (nonatomic, assign) RLPackButtonMode packButtonMode;


// stickers view customization methods
- (void)setInfo:(RLStickerInfo *)info forStickerAtIndex:(NSInteger)index inPack:(NSInteger)packIndex;

- (void)setInfo:(RLStickerPackInfo *)info forStickerPackAtIndex:(NSInteger)index;

- (void)reloadData;
- (void)updateWatermarks;

- (void)setStatusBarColor:(UIColor *)color;

@end
