//
//  RLComposerWorkflowController.h
//  ROKOStickers
//
//  Created by Alexey Golovenkov on 08.03.15.
//  Copyright (c) 2015 ROKOLabs. All rights reserved.
//

/// @name ROKOStickers

#import <UIKit/UIKit.h>

@class RLPhotoComposerController;

typedef NS_ENUM (NSInteger, RLComposerWorkflowType) {
	kRLComposerWorkflowTypeCamera = 0,
	kRLComposerWorkflowTypePhotoPicker,
	kRLComposerWorkflowTypeStickersSelector
};

@interface RLComposerWorkflowController : UINavigationController

@property (strong, nonatomic) RLPhotoComposerController *composer;

+ (instancetype)buildComposerWorkflowWithType:(RLComposerWorkflowType)type useROKOCMS:(BOOL)useROKOCMS;

@end
