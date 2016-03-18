//
//  ROKONavigationBarScheme.h
//  ROKOStickers
//
//  Created by Alexey Golovenkov on 25.04.15.
//  Copyright (c) 2015 ROKOLabs. All rights reserved.
//

#import "ROKOComponentScheme.h"

@interface ROKONavigationBarScheme : ROKOComponentScheme

@property (nonatomic, copy) NSString *controllerTitle;
@property (nonatomic, assign) BOOL useTextButtons;
@property (nonatomic, copy) NSString *navigationLeftButtonText;
@property (nonatomic, copy) NSString *navigationRightButtonText;
@property (nonatomic, copy) NSString *navigationDoneButtonText;
@property (nonatomic, strong) ROKOFontDataObject *navigationButtonsFont;
@property (nonatomic, strong) ROKOImageDataObject *navigationLeftButtonImageFile;
@property (nonatomic, strong) ROKOImageDataObject *navigationRightButtonImageFile;
@property (nonatomic, strong) ROKOImageDataObject *navigationDoneButtonImageFile;
@property (nonatomic, strong) ROKOFontDataObject *controllerTitleFont;
@property (nonatomic, strong) UIColor *navigationBarColor;

@end
