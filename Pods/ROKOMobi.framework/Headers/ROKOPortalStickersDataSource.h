//
//  ROKOPortalStickersDataSource.h
//  ROKOStickers
//
//  Created by Alexey Golovenkov on 27.05.15.
//  Copyright (c) 2015 ROKOLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROKOComponent.h"
#import "RLPhotoComposerDataSource.h"
#import "ROKOHTTPClient.h"

/**
 *  Implements RLPhotoComposerDataSource protocol for stickers from ROKO Portal
 */

@interface ROKOPortalStickersDataSource : ROKOComponent <RLPhotoComposerDataSource>

- (void)reloadStickersWithCompletionBlock:(ROKOHTTPClientCompletion)completionBlock;

@end
