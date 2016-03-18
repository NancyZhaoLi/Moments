//
//  ROKOSharePreviewScheme.h
//  ROKOShare
//
//  Created by Denis Kempest on 6/11/15.
//  Copyright (c) 2015 ROKOLabs. All rights reserved.
//

#import "ROKOComponentScheme.h"

@interface ROKOSharePreviewScheme : ROKOComponentScheme

@property (strong, nonatomic) ROKOFontDataObject *promptTextFont;
@property (strong, nonatomic) ROKOFontDataObject *staticTextFont;
@property (strong, nonatomic) ROKOImageDataObject *staticImage;
@property (strong, nonatomic) NSString *promptText;
@property (assign, nonatomic) bool useStaticMode;
@property (copy, nonatomic) NSString *staticText;

@end
