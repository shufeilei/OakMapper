//
//  OakMapperLoginViewController.m
//  OakMapper
//
//  Created by Shufei Lei on 3/28/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

#import "OakMapperLoginViewController.h"

@interface OakMapperLoginViewController ()

@end

@implementation OakMapperLoginViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signin:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
