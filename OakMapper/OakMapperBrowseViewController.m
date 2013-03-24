//
//  OakMapperViewViewController.m
//  OakMapper
//
//  Created by Shufei Lei on 3/23/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

#import "OakMapperBrowseViewController.h"
#import "OakMapperDetailViewController.h"
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "OakMapperSODPlacemark.h"

@interface OakMapperBrowseViewController ()

@property (nonatomic, assign) int loadOffset;

- (void)loadSODHelper:(int)numberOfPoints;
- (void)parseSODData:(NSData *)reponseData;
- (void)addToMap:(OakMapperSODPlacemark *) placemark;
- (void)showMap:(float)latitude setLongitude:(float)longitude setRadius:(float)radius;

@end

#define METERS_PER_MILE 1609.344
#define LOAD_INCREMENT 50

@implementation OakMapperBrowseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _loadOffset = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Show the map
    [self showMap:36.0 setLongitude:-120.0 setRadius:400.0];
    // Load the first 50 points from the most recent
    [self loadSODHelper:50];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Functions responding to the action buttons
- (IBAction)loadMoreSODPoints:(id)sender {
     _loadOffset += LOAD_INCREMENT;
    [self loadSODHelper:50];
}

-(void)loadSODHelper:(int)numberOfPoints {
    // Query string creation.
    NSString *queryURI = [[NSString alloc] initWithFormat:@"http://oakmapper.cnr.berkeley.edu/resources/json/%u/%u", numberOfPoints, _loadOffset];
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


#pragma mark UISegmentedControl IBAction method
- (IBAction)switchMapType:(id)sender {
	int maptype = [_segmentMapType selectedSegmentIndex];
    
	if(maptype==0){
		_mapView.mapType=MKMapTypeStandard;
	} else if (maptype==1){
		_mapView.mapType=MKMapTypeSatellite;
	} else if (maptype==2){
		_mapView.mapType=MKMapTypeHybrid;
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
    [self performSegueWithIdentifier:@"showSODBrowseDetail" sender:(OakMapperSODPlacemark *)[view annotation]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"showSODBrowseDetail"]){
        OakMapperDetailViewController *detailViewController = (OakMapperDetailViewController *)[segue destinationViewController];

        // Pass placemark to the destination view controller
        detailViewController.sodPlacemark = sender;
    }
}

- (void)addToMap:(OakMapperSODPlacemark *) placemark {
	[_mapView addAnnotation:placemark];
}

@end
