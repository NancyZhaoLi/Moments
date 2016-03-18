//
//  RLStickerInfo.h
//  ROKOStickers
//
//  Created by Katerina Vinogradnaya on 7/17/14.
//  Copyright (c) 2014 ROKOLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RLStickerInfo : NSObject

@property (assign, nonatomic) NSInteger stickerID;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *iconURL;
@property (copy, nonatomic) NSString *thumbnailURL;
@property (copy, nonatomic) UIImage *icon;
@property (copy, nonatomic) UIImage *thumbnail;
@property (assign, nonatomic) CGFloat scale;
@property (assign, nonatomic) CGFloat maxScale;
@property (assign, nonatomic) CGFloat minScale;
@property (nonatomic, assign) NSInteger positionInPack;

@end
