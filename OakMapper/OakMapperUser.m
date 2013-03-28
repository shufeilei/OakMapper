//
//  OakMapperUser.m
//  OakMapper
//
//  Created by Shufei Lei on 3/28/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

#import "OakMapperUser.h"

@implementation OakMapperUser

+ (OakMapperUser *)sharedOakMapperUser {

    static OakMapperUser *sharedOakMapperUser;    // static instance variable

    @synchronized(self) {
        if ( !sharedOakMapperUser ) {
            // allocate the shared instance, because it hasn't been done yet
            sharedOakMapperUser = [[OakMapperUser alloc] init];
            sharedOakMapperUser.loggedIn = NO;
        }
    }
    return sharedOakMapperUser;
}


@end
