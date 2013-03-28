//
//  OakMapperUser.h
//  OakMapper
//
//  Created by Shufei Lei on 3/28/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OakMapperUser : NSObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *email;
@property (assign, nonatomic) BOOL loggedIn;
@property (assign, nonatomic) int userID;

+ (OakMapperUser *)sharedOakMapperUser;

@end
