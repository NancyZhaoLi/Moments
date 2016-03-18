//
//  ROKOComponentManager.h
//  ROKOComponents
//
//  Created by Katerina Vinogradnaya on 6/27/14.
//  Copyright (c) 2014 ROKOLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	ROKO_SC_SUCCESS = 0,
	ROKO_SC_AUTHENTICATION_FAILED = 1,
	ROKO_SC_ACCESS_DENIED = 2,
	ROKO_SC_OBJECT_NOT_FOUND = 3,
	ROKO_SC_BAD_REQUEST = 4,
	ROKO_SC_OBJECT_ALREADY_EXISTS = 5,
	ROKO_SC_BAD_PARAMETER_VALUE = 6,
	ROKO_SC_API_KEY_MISSED = 7,
	ROKO_SC_API_KEY_INVALID = 8,
	ROKO_SC_PUSH_NOTIFICATION_SCHEDULE_INVALID = 9,
	ROKO_SC_UNIDENTIFIED_ERROR = 10
} ROKOStatusCode;

@class ROKOHTTPClient;

typedef void (^ROKOComponentManagerCompletion)(ROKOStatusCode statusCode, NSError *error);

/**
 *  Manages instances of ROKOComponent inheritors
 */
@interface ROKOComponentManager : NSObject

/**
 *  Path to server API. Sample: "api.roko.mobi/v1/". Default value loads from ROKOMobiAPIURL value of application's info.plist file
 */
@property (nonatomic, copy) NSString *baseURL;

/**
 *  API token of the application to work with. Default value loads from ROKOMobiAPIToken value of application's info.plist file
 */
@property (nonatomic, copy) NSString *apiToken;

/**
 *  Indicates if token and base URL are correct and components can be used without limitations
 */
@property (nonatomic, assign) BOOL isApiTokenValid;

/**
 *  Default instance of ROKOComponentManager
 */
+ (instancetype)sharedManager;

/**
 *  Initializes a new instance of component manager.
 *
 *  @param baseURL Path to API
 *
 *  @return Initialized manager
 */
- (instancetype)initWithURL:(NSString *)baseURL;

/**
 *  @return HTTP client associated with current manager
 */
- (ROKOHTTPClient *)baseHTTPClient;

/**
 *  Registers an object to be accessed by name
 *
 *  @param object     Object to be stored
 *  @param objectName String that identifies the object
 */
- (void)registerObject:(NSObject *)object withName:(NSString *)objectName;

/**
 *  Finds an object in the list of registered objects by it's name.
 *
 *  @param objectName Object identifier
 *
 *  @return Found object or nil if there is no objects for given objectName
 */
- (NSObject *)objectWithName:(NSString *)objectName;

/**
 *  Removes the given object from the list of registered objects
 *
 *  @param object Object to be forgotten
 */
- (void)unregisterObject:(NSObject *)object;

/**
 *  Removes object with the given identifier from the list of registered object
 *
 *  @param objectName Identifier of object to be forgotten
 */
- (void)unregisterObjectWithName:(NSString *)objectName;

- (void)checkApiTokenWithCompletion:(ROKOComponentManagerCompletion)completion;

@end
