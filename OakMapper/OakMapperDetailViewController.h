//
//  OakMapperDetailViewController.h
//  OakMapper
//
//  Created by Shufei Lei on 3/23/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

@class OakMapperSODPlacemark;

@interface OakMapperDetailViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *oakSpeciesLabel;
@property (weak, nonatomic) IBOutlet UILabel *oakCollectDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *oakDescriptionText;

@property (weak, nonatomic) IBOutlet UIImageView *oakImage;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) OakMapperSODPlacemark *sodPlacemark;

@end
