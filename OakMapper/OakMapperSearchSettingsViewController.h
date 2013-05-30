//
//  OakMapperSearchSettingsViewController.h
//  OakMapper
//
//  Created by Shufei Lei on 4/26/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OakMapperSearchSettingsViewController;

@protocol OakMapperSearchSettingsViewControllerDelegate <NSObject>
- (void)setSearchSettings:(OakMapperSearchSettingsViewController *)controller location:(NSString *)location radius:(int)radius;
@end

@interface OakMapperSearchSettingsViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *locationTF;
@property (weak, nonatomic) IBOutlet UIPickerView *radiusPicker;
@property (strong, nonatomic) NSArray *radiusOptions;
@property (strong, nonatomic) NSArray *radii;

@property (weak, nonatomic) id <OakMapperSearchSettingsViewControllerDelegate> delegate;

- (IBAction)updateSearchSettings:(id)sender;
@end
