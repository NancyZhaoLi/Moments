//
//  ROKOStickersCustomizer.h
//  ROKOStickers
//
//  Created by Alexey Golovenkov on 17.04.15.
//  Copyright (c) 2015 ROKOLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ROKOStickersScheme.h"
#import "ROKOComponentCustomizer.h"

typedef void (^ROKOStickersCustomizerCompletionBlock)(ROKOStickersScheme *scheme, NSError *error);

@interface ROKOStickersCustomizer : ROKOComponentCustomizer

- (void)loadSchemeWithCompletionBlock:(ROKOStickersCustomizerCompletionBlock)completionBlock;

@end
