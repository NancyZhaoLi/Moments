//
//  RSActivityViewController.h
//  ROKOShare
//
//  Created by Katerina Vinogradnaya on 08.05.14.
//  Copyright (c) 2014 ROKOLabs LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ROKOShareScheme.h"

/**
 *  Possible values of sharing process
 */
typedef NS_ENUM(NSInteger, ROKOSharingResult){
	/**
	 *  Content was successfully shared
	 */
	ROKOSharingResultDone = 0,
	/**
	 *  Sharing was cancelled by used
	 */
	ROKOSharingResultCancelled,
	/**
	 *  Content was not shared because of error
	 */
	ROKOSharingResultFailed
};


@class RSActivityViewController;

@protocol RSActivityViewControllerDelegate <NSObject>

@optional

- (void)activityController:(RSActivityViewController *)controller didFinishWithActivityType:(ROKOShareChannelType)activityType result:(ROKOSharingResult)result;
- (void)activityControllerDidCancel:(RSActivityViewController *)controller;

@end


/**
 *  Share view controller
 */
@interface RSActivityViewController : UIViewController

/**
 *  Delegate of the Share controller
 */
@property (weak, nonatomic) id<RSActivityViewControllerDelegate>delegate;

/**
 *  ROKOShareScheme for customizing appearence of view
 */
@property (strong, nonatomic) ROKOShareScheme *shareScheme;

/**
 *  shouldLoadSchemeFromPortal if YES load scheme from portal, if NO scheme should be configured locally
 */
@property (assign, nonatomic) BOOL shouldLoadSchemeFromPortal;

/**
 *  Image to be shared
 */
@property (nonatomic, strong) UIImage *image;

/**
 *  Background image for share view
 */
@property (weak, nonatomic) UIImage *backgroundImage;

/**
 *  Unique identifier of sharing content. May be nill
 */
@property (nonatomic, copy) NSString *contentId;

/**
 *  Type of sharing content. Used for analytic.
 */
@property (nonatomic, copy) NSString *contentType;

/**
 *  Default comment for sharing content
 */
@property (copy, nonatomic) NSString *displayMessage;

/**
 *  Video data to be shared
 */
@property (nonatomic, strong) NSData *videoData;

/**
 *  URL of sharing content
 */
@property (strong, nonatomic) NSURL *URL;

+ (instancetype)buildController;

@end
