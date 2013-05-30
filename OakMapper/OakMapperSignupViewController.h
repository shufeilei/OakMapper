//
//  OakMapperSignupViewController.h
//  OakMapper
//
//  Created by Shufei Lei on 5/4/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OakMapperSignupViewController : UIViewController <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIButton *selectBkgButton;

- (IBAction)selectBackground:(id)sender;
- (IBAction)cancelSignup:(id)sender;

@end
