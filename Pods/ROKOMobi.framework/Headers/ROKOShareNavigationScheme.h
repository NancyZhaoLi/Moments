//
//  ROKOShareNavigationScheme.h
//  ROKOShare
//
//  Created by Denis Kempest on 6/11/15.
//  Copyright (c) 2015 ROKOLabs. All rights reserved.
//

#import "ROKOComponentScheme.h"

@interface ROKOShareNavigationScheme : ROKOComponentScheme

@property (assign, nonatomic) bool closeButtonEnabled;
@property (strong, nonatomic) ROKOImageDataObject *closeButtonImageFile;
@property (strong, nonatomic) ROKOFontDataObject *closeButtonTextFont;
@property (assign, nonatomic) bool doneButtonEnabled;
@property (strong, nonatomic) ROKOImageDataObject *doneButtonImageFile;
@property (strong, nonatomic) ROKOFontDataObject *doneButtonTextFont;
@property (assign, nonatomic) bool useTextForCloseButton;
@property (assign, nonatomic) bool useTextForDoneButton;
@property (strong, nonatomic) NSString *doneButtonText;
@property (strong, nonatomic) NSString *closeButtonText;

@end
