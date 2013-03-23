//
//  OakMapperSOD.h
//  OakMapper
//
//  Created by Shufei Lei on 3/21/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

@interface OakMapperSOD : NSObject {
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
	NSString *description;
	NSString *submitType;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *submitType;

@end
