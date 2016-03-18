//
//  ROKOPortalManager.h
//  ROKODoodles
//
//  Created by Maslov Sergey on 03.08.15.
//  Copyright (c) 2015 ROKOLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROKOComponent.h"


@class ROKOUserObject;
@class ROKOPortalManager;

@protocol ROKOPortalManagerDelegate
@optional
- (void)portalManagerDidLogin:(ROKOPortalManager *)manager;
- (void)portalManagerDidLogout:(ROKOPortalManager *)manager;
- (void)portalManagerDidSignup:(ROKOPortalManager *)manager;

- (void)portalManager:(ROKOPortalManager *)manager didFailLoginWithError:(NSError *)error;
- (void)portalManager:(ROKOPortalManager *)manager didFailLogoutWithError:(NSError *)error;
- (void)portalManager:(ROKOPortalManager *)manager didFailSignupWithError:(NSError *)error;
@end

#import "ROKOUserObject.h"

/**
 *  Provides API for login/logout/signup to ROKO Portal. Uses ROKOHTTPClient.
 */
@interface ROKOPortalManager : ROKOComponent

/**
 *  Delegate which accept ROKOPortalManagerDelegate protocol
 */
@property (weak, nonatomic) id <ROKOPortalManagerDelegate> delegate;

@property (nonatomic, readonly) BOOL isLogin;
@property (nonatomic, strong) NSString *sessionKey;
@property (nonatomic, strong) ROKOUserObject *userInfo;
@property (nonatomic, strong) NSString *applicationName;

- (void)loginWithUser:(NSString *)name andPassword:(NSString *)password;
- (void)logout;
- (void)signupUser:(NSString *)name andPassword:(NSString *)password;
@end
