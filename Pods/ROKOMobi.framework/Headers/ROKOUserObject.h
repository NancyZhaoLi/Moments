//
//  ROKOUserObject.h
//  ROKOMobi
//
//  Created by Maslov Sergey on 18.08.15.
//  Copyright (c) 2015 ROKO Labs. All rights reserved.
//

#import <ROKOMobi/ROKOMobi.h>
#import "ROKODataObject.h"

/**
 *  Stores information about ROKO Portal user
 */
@interface ROKOUserObject : ROKODataObject

@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) ROKODataObject *developmentCompany;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstLoginTime;
@property (nonatomic, strong) NSString *lastLoginTime;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *photoFile;
@property (nonatomic, strong) NSDictionary *systemProperties;
@property (nonatomic, strong) NSString *updateDate;
@property (nonatomic, strong) NSString *username;

@end
