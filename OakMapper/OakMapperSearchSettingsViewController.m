//
//  OakMapperSearchSettingsViewController.m
//  OakMapper
//
//  Created by Shufei Lei on 4/26/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

#import "OakMapperSearchSettingsViewController.h"

@interface OakMapperSearchSettingsViewController ()

@end

@implementation OakMapperSearchSettingsViewController

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
    _radiusOptions = [[NSArray alloc] initWithObjects:
                      @"50.0 miles", @"100.0 miles", @"200.0 miles", @"500.0 miles", @"1000.0 miles", nil];
    
    _radii = [[NSArray alloc] initWithObjects: [NSNumber numberWithInteger:50],
              [NSNumber numberWithInteger:100],
              [NSNumber numberWithInteger:200],
              [NSNumber numberWithInteger:500],
              [NSNumber numberWithInteger:1000], nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark PickerView DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_radiusOptions count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_radiusOptions objectAtIndex:row];
}

#pragma mark PickerView Delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    int radius = [[_radii objectAtIndex:row] integerValue];
    NSLog(@"%i",radius);
}

- (IBAction)updateSearchSettings:(id)sender {
}
@end
