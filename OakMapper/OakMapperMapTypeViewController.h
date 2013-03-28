//
//  OakMapperMapTypeViewController.h
//  OakMapper
//
//  Created by Shufei Lei on 3/27/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface OakMapperMapTypeViewController : UIViewController

@property (weak, nonatomic) MKMapView *mapView;
@property (assign, nonatomic) int mapType;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSegment;

- (IBAction)changeMapType:(id)sender;

@end
