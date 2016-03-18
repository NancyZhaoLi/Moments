//
//  RLImageCaptureViewController.h
//  ROKOStickers
//
//  Created by Katerina Vinogradnaya on 01.05.14.
//  Copyright (c) 2014 ROKOLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RLImageCaptureViewController;

/**
 *  Delegate for RLImageCaptureViewController class
 */
@protocol RLImageCaptureViewControllerDelegate <NSObject>

@optional

/**
 *  Informs delegate that image is captured
 *
 *  @param photo Image that was captured or selected from gallery
 */
- (void)imageCaptureController:(RLImageCaptureViewController *)controller didFinishWithPhoto:(UIImage *)photo;

/**
 *  Informs delegate that user pressed Cancel button
 */
- (void)imageCaptureControllerDidCancel:(RLImageCaptureViewController *)controller;

@end

/**
 *  Implements camera handling
 */
@interface RLImageCaptureViewController : UIViewController

/**
 *  Delegate
 */
@property (weak, nonatomic) id <RLImageCaptureViewControllerDelegate> delegate;

/**
 *  Stores Image Source Type
 */

@property (assign, nonatomic) UIImagePickerControllerSourceType imageSourceType;

/**
 *  Creates and returns a new instance of RLImageCaptureViewController class
 */
+ (instancetype)buildImageCaptureController;

@end
