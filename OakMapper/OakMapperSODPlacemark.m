//
//  OakMapperSODPlacemark.m
//  OakMapper
//
//  Created by Shufei Lei on 3/21/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

#import "OakMapperSODPlacemark.h"

@implementation OakMapperSODPlacemark

-(id)initWithCoordinate:(CLLocationCoordinate2D) coords 
{
	
	self = [super init];
	
	if (self != nil) {
		_coordinate = coords;
	}
	
	//NSLog(@"%f, %f", coords.latitude, coords.longitude);
	return self;
}

- (NSString *) title
{
	return _theTitle;
}

- (NSString *) subtitle
{
	return _theSubtitle;
}

@end