//
//  OakMapperSODPlacemark.h
//  OakMapper
//
//  Created by Shufei Lei on 3/21/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface OakMapperSODPlacemark : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSString *theTitle;
@property (strong, nonatomic) NSString *theSubtitle;
@property (strong, nonatomic) NSString *submitType;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *imageURL;

-(id)initWithCoordinate:(CLLocationCoordinate2D) coords;
-(NSString *) title;
-(NSString *) subtitle;

@end
