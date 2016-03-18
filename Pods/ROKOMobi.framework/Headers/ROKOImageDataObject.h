//
//  ROKOImageDataObject.h
//  ROKOComponents
//
//  Created by Alexey Golovenkov on 21.04.15.
//  Copyright (c) 2015 ROKOLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ROKODataObject.h"

/**
 *  Stores information about image loaded from ROKO Portal
 */
@interface ROKOImageDataObject : ROKODataObject

/**
 *  URL of the remote image.
 */
@property (nonatomic, strong) NSString *imageURL;

/**
 *  Downloaded image. It's strongly recommended to avoid using this property in huge amounts of images to minimize memory cost.
 */
@property (nonatomic, strong) UIImage *image;

@end
