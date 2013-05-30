//
//  OakMapperSearchViewController.m
//  OakMapper
//
//  Created by Shufei Lei on 3/24/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

#import "OakMapperSearchViewController.h"
#import "OakMapperDetailViewController.h"
#import "OakMapperSearchSettingsViewController.h"
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "OakMapperSODPlacemark.h"

@interface OakMapperSearchViewController ()

- (void)initLocation;
- (void)loadSODWithLatitude:(float)latitude longitude:(float)longitude radius:(float)radius;
- (void)parseSODData:(NSData *)reponseData;
- (void)addToMap:(OakMapperSODPlacemark *) placemark;
- (void)showMap:(float)latitude setLongitude:(float)longitude setRadius:(float)radius;

@end

#define METERS_PER_MILE 1609.344
#define DEFAULT_RADIUS 5

@implementation OakMapperSearchViewController

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
    // Show the map
    [self initLocation];
    // Load the first 50 points from the most recent
}

- (IBAction)changeMapType:(id)sender {
    int maptype = [_mapTypeSegment selectedSegmentIndex];
    
	if(maptype==0){
		_mapView.mapType=MKMapTypeStandard;
	} else if (maptype==1){
		_mapView.mapType=MKMapTypeSatellite;
	} else if (maptype==2){
		_mapView.mapType=MKMapTypeHybrid;
	}
}

- (void)initLocation {
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
        hud.labelText = @"Zooming in...";
        
        NSLog(@"Location has started to update...");
        
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
    if (_bestEffortAtLocation == nil || _bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        // store the location as the "best effort"
        _bestEffortAtLocation = newLocation;
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
    _stateString = state;
    [_locationManager stopUpdatingLocation];
    NSLog(@"Core Location has stopped updating.");
    
    _locationManager.delegate = nil;
    
    // Add at start of setCompletionBlock and setFailedBlock blocks
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    
    // Dispaly the latitude and longitude in the textfields
    [self.searchTextfield setText:[NSString stringWithFormat:@"%f, %f", _bestEffortAtLocation.coordinate.latitude, _bestEffortAtLocation.coordinate.longitude]];
    
    // Display location on the map
    [self showMap:_bestEffortAtLocation.coordinate.latitude setLongitude:_bestEffortAtLocation.coordinate.longitude setRadius:DEFAULT_RADIUS];

    // Load points in the area of the map
    //[self loadSODWithLatitude:_bestEffortAtLocation.coordinate.latitude longitude:_bestEffortAtLocation.coordinate.longitude radius:DEFAULT_RADIUS];

}


- (void)showMap:(float)latitude setLongitude:(float)longitude setRadius:(float)radius {
    // Create my location
    CLLocationCoordinate2D myLocation;
    myLocation.latitude = latitude; // my location's latitude
    myLocation.longitude = longitude; // my location's longitude
    
    // Create region with my location in the center
    // Might need to change the radius of the region
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(myLocation, radius*METERS_PER_MILE, radius*METERS_PER_MILE);
    
    // Set map delegate to self
    [_mapView setDelegate:self];
    // Show the region on the map
    [_mapView setRegion:viewRegion animated:YES];

    MKCircle *circle = [MKCircle circleWithCenterCoordinate:myLocation radius:1000];
    [_mapView addOverlay:circle];
    [_mapView setRegion:MKCoordinateRegionForMapRect(circle.boundingMapRect)];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Functions responding to the action buttons
-(void)loadSODWithLatitude:(float)latitude longitude:(float)longitude radius:(float)radius {
    // Query SOD points by location
    NSString *queryURI = [NSString stringWithFormat:@"http://oakmapper.cnr.berkeley.edu/mobile/json/lat:%f/lon:%f/radius:%f", latitude, longitude, radius];
    NSURL *url = [NSURL URLWithString:queryURI];
    //NSLog(@"Query URL: %@", queryURI);
    
    // Setting up the request object to be weak so that it's not retained
    ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
    __weak ASIHTTPRequest *request = _request;
    
    request.requestMethod = @"GET";
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setDelegate:self];
    
    // Setting up the completion block
    [request setCompletionBlock:^{
        // Stop the animation
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        // Get the request JSON response in string format
        //NSString *responseString = [request responseString];
        //NSLog(@"Response: %@", responseString);
        
        [self parseSODData:request.responseData];
    }];
    [request setFailedBlock:^{
        // Stop the animation
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        // Debug the error
        //NSError *error = [request error];
        //NSLog(@"Error: %@", error.localizedDescription);
    }];
    
    // Start the request
    [request startAsynchronous];
    
    // Start the activity porgress animation
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading SOD trees...";
    
}

- (void)parseSODData:(NSData *)responseData {
    NSDictionary *root = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    NSArray *oaks = [root objectForKey:@"oaks"];
    
    for (NSDictionary *oak in oaks) {
        NSString *geomType = [oak objectForKey:@"geomType"];
        if ([geomType isEqualToString:@"POINT"]) {
            NSArray *oakCoor = [oak objectForKey:@"point"];
            CLLocationCoordinate2D oakLocation;
            oakLocation.latitude = [oakCoor[0] floatValue];
            oakLocation.longitude = [oakCoor[1] floatValue];
            OakMapperSODPlacemark *sodPlacemark = [[OakMapperSODPlacemark alloc] initWithCoordinate:oakLocation];
            [sodPlacemark setTheTitle:[oak objectForKey:@"title"]];
            [sodPlacemark setTheSubtitle:[oak objectForKey:@"pubDate"]];
            [sodPlacemark setDescription:[oak objectForKey:@"description"]];
            [sodPlacemark setSubmitType:geomType];
            // Get the image URL if there is one
            //[sodPlacemark setImageURL:[oak objectForKey:@"imageURL"]];
            
            [self performSelectorOnMainThread:@selector(addToMap:) withObject:sodPlacemark waitUntilDone:NO];
        }
	}
}

#pragma mark MKMapView delegate methods
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    detailButton.frame = CGRectMake(0, 0, 23, 23);
    detailButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    detailButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    MKAnnotationView *annView=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"allsods"];
    if ([[(OakMapperSODPlacemark *)annotation submitType] isEqualToString:@"CommunityOak"]) {
        [annView setImage:[UIImage imageNamed:@"orange-circle.png"]];
    } else {
        [annView setImage:[UIImage imageNamed:@"red-circle.png"]];
    }
    [annView setRightCalloutAccessoryView:detailButton];
    [annView setCanShowCallout:YES];
    
    return annView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self performSegueWithIdentifier:@"showSODDetail" sender:(OakMapperSODPlacemark *)[view annotation]];
}

// Overlay properties
- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    circleView.strokeColor = [UIColor redColor];
    circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
    return circleView;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"showSODDetail"]){
        OakMapperDetailViewController *detailViewController = (OakMapperDetailViewController *)[segue destinationViewController];
        
        // Pass placemark to the destination view controller
        detailViewController.sodPlacemark = sender;
    }
    
    /*
    if ([segue.identifier isEqualToString:@"searchSettings"]) {
        OakMapperSearchSettingsViewController *searchSettingViewController = (OakMapperSearchSettingsViewController *)[segue destinationViewController];
        
    }
     */

}

- (void)addToMap:(OakMapperSODPlacemark *) placemark {
	[_mapView addAnnotation:placemark];
}

#pragma mark UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.searchTextfield) {
        [theTextField resignFirstResponder];
    }
    
    // if latTextfield and lonTextfield both have values, update Map
    if (self.searchTextfield.text != nil) {
        // Geocode the location and search points to display on map
        
        //[self showMap:[self.latTextfield.text floatValue] setLongitude:[self.lonTextfield.text floatValue]];
        
    }
    
    return YES;
}

@end
