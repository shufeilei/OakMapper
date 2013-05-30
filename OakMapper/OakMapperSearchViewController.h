//
//  OakMapperSearchViewController.h
//  OakMapper
//
//  Created by Shufei Lei on 3/24/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface OakMapperSearchViewController : UIViewController <MKMapViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *bestEffortAtLocation;
@property (strong, nonatomic) NSString *stateString;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextfield;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSegment;

- (IBAction)changeMapType:(id)sender;

@end
