//
//  OakMapperSubmitLocationViewController.m
//  OakMapper
//
//  Created by Shufei Lei on 3/22/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

#import "OakMapperSubmitLocationViewController.h"
#import "MBProgressHUD.h"

@interface OakMapperSubmitLocationViewController ()

@end

#define METERS_PER_MILE 1609.344

@implementation OakMapperSubmitLocationViewController

@synthesize bestEffortAtLocation, stateString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // If user permits the application to obtain location, populate text feild with user location
    
    
    // If not, tell them to enter lat and long using the text field.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBAction methods
- (IBAction)getLocation:(id)sender {
    // Create the manager object
    if ([CLLocationManager locationServicesEnabled]) {
        if(_locationManager==nil){
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = self;
            _locationManager.distanceFilter = 1000; // 1 kilometer
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        }
        [_locationManager startUpdatingLocation];

        // Add right after [request startAsynchronous] in refreshTapped action method
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Getting location...";
        
        NSLog(@"Location has started to update...");

        [self.latTextfield setText:@"Updating..."];
        [self.lonTextfield setText:@"Updating..."];
        [self performSelector:@selector(stopUpdatingLocation:) withObject:@"Timed Out" afterDelay:5.0];
        
    } else {
        // Tell user to put in the coordinates by hand
        
    }
}

#pragma mark Core Loation Manager delegate
// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
	       fromLocation:(CLLocation *)oldLocation
{
	// Disable future updates to save power.
	NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    NSLog(@"Time has elpased: %f", locationAge);
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    if (locationAge > 5) return;
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        // store the location as the "best effort"
        bestEffortAtLocation = newLocation;
        // test the measurement to see if it meets the desired accuracy
        //
        // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue
        // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of
        // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
        //
        if (newLocation.horizontalAccuracy <= _locationManager.desiredAccuracy) {
            // we have a measurement that meets our requirements, so we can stop updating the location
            //
            // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
            //
            [self stopUpdatingLocation:NSLocalizedString(@"Acquired Location", @"Acquired Location")];
            // we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:nil];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a
    // timeout that will stop the location manager to save power.
    if ([error code] != kCLErrorLocationUnknown) {
        [self stopUpdatingLocation:NSLocalizedString(@"Error", @"Error")];
    }
}

- (void)stopUpdatingLocation:(NSString *)state {
    stateString = state;
    [_locationManager stopUpdatingLocation];
    NSLog(@"Core Location has stopped updating.");

    _locationManager.delegate = nil;

    // Add at start of setCompletionBlock and setFailedBlock blocks
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    

    // Dispaly the latitude and longitude in the textfields
    [self.latTextfield setText:[NSString stringWithFormat:@"%f", bestEffortAtLocation.coordinate.latitude]];
    [self.lonTextfield setText:[NSString stringWithFormat:@"%f", bestEffortAtLocation.coordinate.longitude]];
    
    // Display location on the map
    [self showMap:bestEffortAtLocation.coordinate.latitude setLongitude:bestEffortAtLocation.coordinate.longitude];

    
}

#pragma mark UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.latTextfield || theTextField == self.lonTextfield) {
        [theTextField resignFirstResponder];
    }
    
    // if latTextfield and lonTextfield both have values, update Map
    if (self.latTextfield.text != nil && self.lonTextfield != nil) {
        [self showMap:[self.latTextfield.text floatValue] setLongitude:[self.lonTextfield.text floatValue]];
        
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 160; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

#pragma mark MKMapKit delegate


- (void)showMap:(float)latitude setLongitude:(float)longitude {
    // Create my location
    CLLocationCoordinate2D myLocation;
    myLocation.latitude = latitude; // my location's latitude
    myLocation.longitude = longitude; // my location's longitude
    
    // Create region with my location in the center
    // Might need to change the radius of the region
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(myLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    // Show the region on the map
    [_mapView setRegion:viewRegion animated:YES];
}



@end
