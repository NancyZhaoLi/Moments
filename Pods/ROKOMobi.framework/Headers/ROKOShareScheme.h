//
//  ROKOShareButtonScheme.h
//  ROKOShareDemo
//
//  Created by Katerina Vinogradnaya on 7/31/14.
//  Copyright (c) 2014 ROKOLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ROKOComponentScheme.h"
#import "ROKOShareNavigationScheme.h"
#import "ROKOSharePreviewScheme.h"
#import "ROKOShareChannelScheme.h"

/**
 *  Scheme for ROKO Share component
 */
@interface ROKOShareScheme : ROKOComponentScheme

/**
 *  Array of ROKOShareChannelScheme objects. List of avaliable share channels.
 */
@property (strong, nonatomic) NSMutableArray *channels;

/**
 *  Background color for share view.
 */
@property (strong, nonatomic) UIColor *backgroundColor;

/**
 *  Describes navigation scheme for Share component.
 */
@property (strong, nonatomic) ROKOShareNavigationScheme *navigationScheme;

/**
 *  Describes main view of Share component
 */
@property (strong, nonatomic) ROKOSharePreviewScheme *previewScheme;

/**
 *  Searches scheme for specified type
 *
 *  @param type Type of the sheme to be returned
 *
 *  @return Scheme description or nil if necessary scheme was not found
 */
- (ROKOShareChannelScheme *)channelSchemeWithType:(ROKOShareChannelType)type;

@end
