//
//  ROKOStickersScheme.h
//  ROKOStickers
//
//  Created by Alexey Golovenkov on 21.04.15.
//  Copyright (c) 2015 ROKOLabs. All rights reserved.
//

#import "ROKOComponentScheme.h"
#import "ROKOStickersWatermarkInfo.h"
#import "ROKONavigationBarScheme.h"
#import "ROKOStickersTrayScheme.h"

@interface ROKOStickersScheme : ROKOComponentScheme

@property (nonatomic, assign) BOOL addDefaultWatermark;
@property (nonatomic, strong) ROKOStickersWatermarkInfo *watermarkInfo;
@property (nonatomic, assign) BOOL configurationViaPortal;
@property (nonatomic, assign) BOOL autosaveToAlbum;
@property (nonatomic, copy) NSString *albumName;
@property (nonatomic, strong) ROKONavigationBarScheme *navigationBarScheme;
@property (nonatomic, strong) ROKOStickersTrayScheme *trayScheme;

@end
