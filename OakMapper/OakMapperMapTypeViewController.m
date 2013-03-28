//
//  OakMapperMapTypeViewController.m
//  OakMapper
//
//  Created by Shufei Lei on 3/27/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

#import "OakMapperMapTypeViewController.h"

@interface OakMapperMapTypeViewController ()

@end

@implementation OakMapperMapTypeViewController

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
    if(_mapType==MKMapTypeStandard){
        _mapTypeSegment.selectedSegmentIndex = 0;
    } else if (_mapType==MKMapTypeSatellite){
        _mapTypeSegment.selectedSegmentIndex = 1;
    } else if (_mapType==MKMapTypeHybrid){
        _mapTypeSegment.selectedSegmentIndex = 2;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
