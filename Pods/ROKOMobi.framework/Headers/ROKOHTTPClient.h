//
//  ROKOHTTPClient.h
//  ROKOComponents
//
//  Created by Katerina Vinogradnaya on 6/27/14.
//  Copyright (c) 2014 ROKOLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ROKOComponent.h"


typedef void (^ROKOHTTPClientCompletion)(id responseObject, NSError *error);
typedef void (^ROKOHTTPClientCompletionWithURL)( NSURL *url, id responseObject, NSError *error);

/**
 *  Provides API for uploading data to and downloading content from ROKO Portal. Uses NSURLSession.
 */
@interface ROKOHTTPClient : ROKOComponent

/**
 *  Loads content using GET HTTP method
 *
 *  @param URLString  Path to the content to be loaded. Must contain the path to the content only. Server URL should be specified in assigned manager.
 *  @param parameters Parameters and values to be sent in address string
 *  @param completion Block to be call when responce is received (or error occured)
 *  @see ROKOComponentManager.baseURL
 */
- (void)getDataWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters completion:(ROKOHTTPClientCompletion)completion;

/**
 *  Loads content using GET HTTP method
 *
 *  @param URLString  Path to the content to be loaded. Must contain the path to the content only. Server URL should be specified in assigned manager.
 *  @param parameters Parameters and values to be sent in address string
 *  @param headers    Additional headers to be included into request
 *  @param completion Block to be call when responce is received (or error occured)
 *  @see ROKOComponentManager.baseURL
 */
- (void)getDataWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters customHeaders:(NSDictionary *)headers completion:(ROKOHTTPClientCompletion)completion;

/**
 *  Sends data to server using POST HTTP method
 *
 *  @param URLString  Path to the content to be loaded. Must contain the path to the content only. Server URL should be specified in assigned manager.
 *  @param parameters Additional parameters
 *  @param headers    Additional headers to be included into request
 *  @param body       Data to be posted
 *  @param completion Block to be call when responce is received (or error occured)
 *  @see ROKOComponentManager.baseURL
 */
- (void)postDataWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters body:(NSData *)body customHeaders:(NSDictionary *)headers completion:(ROKOHTTPClientCompletion)completion;

/**
 *  Sends data to server using POST HTTP method
 *
 *  @param URLString  Path to the content to be loaded. Must contain the path to the content only. Server URL should be specified in assigned manager.
 *  @param parameters Additional parameters
 *  @param body       Data to be posted
 *  @param completion Block to be call when responce is received (or error occured)
 *  @see ROKOComponentManager.baseURL
 */
- (void)postDataWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters body:(NSData *)body completion:(ROKOHTTPClientCompletion)completion;

/**
 *  Sends data to server using DELETE HTTP method
 *
 *  @param URLString  Path to the content to be loaded. Must contain the path to the content only. Server URL should be specified in assigned manager.
 *  @param parameters Additional parameters
 *  @param headers    Additional headers to be included into request
 *  @param completion Block to be call when responce is received (or error occured)
 *  @see ROKOComponentManager.baseURL
 */
- (void)deleteRequestWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters customHeaders:(NSDictionary *)headers completion:(ROKOHTTPClientCompletion)completion;

/**
 *  Downloads image from server
 *
 *  @param url        Full URL to image. baseURL property of associated component manager
 *  @param completion Block to be call when responce is received (or error occured)
 */
- (void)downloadImageWithURL:(NSURL *)url completion:(ROKOHTTPClientCompletionWithURL)completion;

/**
 *  Sends data to server using PUT HTTP method
 *
 *  @param URLString  Path to the content to be loaded. Must contain the path to the content only. Server URL should be specified in assigned manager.
 *  @param parameters Additional parameters
 *  @param headers    Additional headers to be included into request
 *  @param body       Data to be posted
 *  @param completion Block to be call when responce is received (or error occured)
 *  @see ROKOComponentManager.baseURL
 */
- (void)putDataWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters body:(NSData *)body customHeaders:(NSDictionary *)headers completion:(ROKOHTTPClientCompletion)completion;

@end
