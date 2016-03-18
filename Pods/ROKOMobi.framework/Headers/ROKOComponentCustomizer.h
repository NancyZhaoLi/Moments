//
//  ROKOComponentCustomizer.h
//  ROKOComponents
//
//  Created by Alexey Golovenkov on 17.04.15.
//  Copyright (c) 2015 ROKOLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROKOComponentScheme.h"
#import "ROKOComponent.h"

@class ROKOImageCache;

/**
 *  Block to be called when scheme loading is finished
 *
 *  @param scheme Loaded data to be parsed to sceme or nil in case of error
 *  @param error      Error description. Nil if loading finished successfully
 */
typedef void (^CustomizerCompletionBlock)(ROKOComponentScheme *scheme, NSError *error);

/**
 *  Manages schemes for different ROKO components
 */
@interface ROKOComponentCustomizer : ROKOComponent

/**
 *  Folder name for store cached scheme. Caching is not activated if this property is nil or empty string.
 */
@property (nonatomic, copy) NSString *cacheFolder;

@property (nonatomic, strong, readonly) ROKOImageCache *cache;

/**
 *  Loads scheme from specified URL
 *
 *  @param urlPath         URL path to scheme
 *  @param completionBlock Block that should be called
 */
- (void)loadSchemeFromURLPath:(NSString *)urlPath withCompletionBlock:(CustomizerCompletionBlock)completionBlock;

/**
 *  Saves scheme to local file
 *
 *  @param scheme       Scheme to be saved
 *  @param schemeName	Name of the scheme
 *
 *  @return YES if the scheme is written successfully, otherwise NO.
 */
- (BOOL)saveScheme:(ROKOComponentScheme *)scheme withName:(NSString *)schemeName;

/**
 *  Loads saved scheme from local storage
 *
 *  @param schemeName Name of the scheme to be loaded
 *
 *  @return Loaded scheme or nil
 */
- (ROKOComponentScheme *)savedSchemeWithName:(NSString *)schemeName;

/**
 *  Loads saved scheme from URL
 *
 *  @param schemeURL URL of the scheme to be loaded
 *
 *  @return Loadede scheme or nil
 */
- (ROKOComponentScheme *)savedSchemeWithURL:(NSURL *)schemeURL;

/**
 *  Loads image for given data object
 *
 *  @param imageObject Image data object to be loaded
 */
- (void)loadImageForObject:(ROKOImageDataObject *)imageObject;

- (ROKOComponentScheme *)parseSchemeData:(NSDictionary *)rawData;

- (NSArray *)allImageObjectsInScheme:(ROKOComponentScheme *)scheme;

- (void)addImageObjectToArray:(ROKOImageDataObject *)object toArray:(NSMutableArray *)array;

@end
