//
//  OakMapperBrowseViewController.h
//  OakMapper
//
//  Created by Shufei Lei on 3/23/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface OakMapperBrowseViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;

- (IBAction)loadMoreSODPoints:(id)sender;

@end
