//
//  OakMapperHomeViewController.m
//  OakMapper
//
//  Created by Shufei Lei on 3/21/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

#import "OakMapperHomeViewController.h"

@interface OakMapperHomeViewController ()

@end

@implementation OakMapperHomeViewController

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
    oakMapperUser = [OakMapperUser sharedOakMapperUser];
    
    // If not logged in, hide "My account" button -- Need to create and use a singleton class
    if ([oakMapperUser loggedIn]) {
        _accountBarButton.enabled = YES;
        _loginBarButton.title = @"Logout";
    } else {
        _accountBarButton.enabled = NO;
        _loginBarButton.title = @"Login";
    }
    
    // Else, hide the "Login/Signup" button
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchNearestSubmissions:(id)sender {
    
    // Pass the proper search parameter: 20 Nearest
    
    // Switch to the SearchViewController
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
}

- (IBAction)aboutOakMapper:(id)sender {
	// open an alert with just an OK button
	NSString *about = @"OakMapper is designed to enable officials and community users to track the spread of Phytophthora ramorum using webGIS technologies.  Phytophthora ramorum causes both Sudden Oak Death and Ramorum blight. For more information, please go to oakmapper.org.";
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"About OakMapper" message:about delegate:sender cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
}

- (IBAction)searchLatestSubmissions:(id)sender {

    // Pass the proper search parameter: Latest 20

    
    // Switch to the SearchViewController
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
}


@end
