//
//  OakMapperLoginViewController.h
//  OakMapper
//
//  Created by Shufei Lei on 3/28/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OakMapperLoginViewController : UIViewController

- (IBAction)signin:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UILabel *loginErrorLabel;

@end
