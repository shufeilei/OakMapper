//
//  OakMapperPictureViewController.h
//  OakMapper
//
//  Created by Shufei Lei on 3/24/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface OakMapperPictureViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate>) delegate;
@end
