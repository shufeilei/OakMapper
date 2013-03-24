//
//  OakMapperDetailViewController.m
//  OakMapper
//
//  Created by Shufei Lei on 3/23/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

#import "OakMapperDetailViewController.h"
#import "OakMapperSODPlacemark.h"

@interface OakMapperDetailViewController ()

@end

#define METERS_PER_MILE 1609.344

@implementation OakMapperDetailViewController

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
    _oakSpeciesLabel.text = [_sodPlacemark title];
    _oakCollectDateLabel.text = [_sodPlacemark subtitle];
    _oakDescriptionText.text = [_sodPlacemark description];
    
    if ([_sodPlacemark imageURL] == nil) {
        // Default image: no image available
        [_oakImage setImage:[UIImage imageNamed:@"NoPhoto.png" ]];
    } else {
        //NSURL *url = [NSURL URLWithString:[_sodPlacemark imageURL]];
        NSURL *url = [NSURL URLWithString:@"http://oakmapper.org/files/DSC00703_resized_67x100.jpg"];
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        UIImage *tmpImage = [[UIImage alloc] initWithData:data];
        [_oakImage setImage:tmpImage];
    }
    
    // Put black border around the map
    [_oakImage.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [_oakImage.layer setBorderWidth: 2.0];
    
    [self showMap:_sodPlacemark.coordinate.latitude
        setLongitude:_sodPlacemark.coordinate.longitude
        setRadius:1.0];
    
    // Put black border around the map
    [_mapView.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [_mapView.layer setBorderWidth: 2.0];

    [_mapView addAnnotation:_sodPlacemark];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark MapView setup
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

#pragma mark MKAnnotationView delegate methods
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
	MKAnnotationView *annView=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"sodlocation"];
	if ([[_sodPlacemark submitType] isEqualToString:@"CommunityOak"]) {
		[annView setImage:[UIImage imageNamed:@"orange-circle.png"]];
	} else {
		[annView setImage:[UIImage imageNamed:@"red-circle.png"]];
	}
	[annView setCanShowCallout:NO];
    
	return annView;
}

@end
