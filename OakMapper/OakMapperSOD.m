//
//  OakMapperSOD.m
//  OakMapper
//
//  Created by Shufei Lei on 3/21/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

#import "OakMapperSOD.h"


@implementation SOD

@synthesize coordinate, title, subtitle, description, submitType;

- (void)dealloc {
    [title release];
    [subtitle release];
	[description release];
	[submitType release];
    [super dealloc];
}

@end
