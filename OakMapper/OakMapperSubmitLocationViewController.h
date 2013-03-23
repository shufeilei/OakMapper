//
//  OakMapperSubmitLocationViewController.h
//  OakMapper
//
//  Created by Shufei Lei on 3/22/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface OakMapperSubmitLocationViewController : UIViewController <CLLocationManagerDelegate, UITextFieldDelegate, MKMapViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *bestEffortAtLocation;
@property (nonatomic, retain) NSString *stateString;
@property (weak, nonatomic) IBOutlet UITextField *latTextfield;
@property (weak, nonatomic) IBOutlet UITextField *lonTextfield;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)getLocation:(id)sender;

- (void)stopUpdatingLocation:(NSString *)state;
- (void)showMap;

@end
