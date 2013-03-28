//
//  OakMapperHomeViewController.h
//  OakMapper
//
//  Created by Shufei Lei on 3/21/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

#import "OakMapperUser.h"

@interface OakMapperHomeViewController : UIViewController {
    @private   
        OakMapperUser *oakMapperUser;
}

- (IBAction)searchLatestSubmissions:(id)sender;
- (IBAction)searchNearestSubmissions:(id)sender;
- (IBAction)aboutOakMapper:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *accountBarButton;

@end
