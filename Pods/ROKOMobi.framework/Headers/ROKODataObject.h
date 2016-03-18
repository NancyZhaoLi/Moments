//
//  ROKODataObject.h
//  ROKOComponents
//
//  Created by Alexey Golovenkov on 21.04.15.
//  Copyright (c) 2015 ROKOLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Base class for ROKO Portal data object
 */
@interface ROKODataObject : NSObject <NSCoding>

/**
 *  Uniq object identifier.
 */
@property (nonatomic, strong) NSNumber *objectId;

/**
 *  Initializes a new object with given dictionary.
 *
 *  @param dictionary Dictionary with information about the object
 *
 *  @return An initialized object, or nil if an object could not be created
 *
 *	@see loadFromDictionary:
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 *  Initializes existing object with new data from given dictionary
 *
 *  @param dictionary Dictionary with information about the object
 */
- (void)loadFromDictionary:(NSDictionary *)dictionary;

@end
