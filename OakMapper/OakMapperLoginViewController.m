//
//  OakMapperLoginViewController.m
//  OakMapper
//
//  Created by Shufei Lei on 3/28/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

#import "OakMapperLoginViewController.h"
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"

@interface OakMapperLoginViewController ()
- (void)transmit:(NSString *)email pwd:(NSString *)pwd;
- (void)processResponse:(NSData *)reponseData;

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

-(void)transmit:(NSString *)email pwd:(NSString *)pwd {
    // Logging into OakMapper mobile
    NSURL *mobileURI = [NSURL URLWithString:@"http://www.oakmapper.org/mobile"];
    
    // Setting up the request object to be weak so that it's not retained
    ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:mobileURI];
    __weak ASIHTTPRequest *request = _request;
    
    request.requestMethod = @"POST";
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setDelegate:self];
    
    // Setting up the completion block
    [request setCompletionBlock:^{
        // Stop the animation
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        // Get the request JSON response in string format
        //NSString *responseString = [request responseString];
        //NSLog(@"Response: %@", responseString);
        
        [self processResponse:request.responseData];
    }];
    [request setFailedBlock:^{
        // Stop the animation
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        // Debug the error
        //NSError *error = [request error];
        //NSLog(@"Error: %@", error.localizedDescription);
    }];
    
    // Start the request
    [request startAsynchronous];
    
    // Start the activity porgress animation
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Authenticating...";
    
}

- (void)processResponse:(NSData *)responseData {
    
    // if login is successful, create a singleton OakMpaperUser
    
    // dismiss signin view controller and go to home view controller
    
    // if login is unsuccessful, state the reasons for failure and encourage to try again
    
}

/*
- (void)parseSODData:(NSData *)responseData {
    NSDictionary *root = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    NSArray *oaks = [root objectForKey:@"oaks"];
    
    for (NSDictionary *oak in oaks) {
        NSString *geomType = [oak objectForKey:@"geomType"];
        if ([geomType isEqualToString:@"POINT"]) {
            NSArray *oakCoor = [oak objectForKey:@"point"];
            CLLocationCoordinate2D oakLocation;
            oakLocation.latitude = [oakCoor[0] floatValue];
            oakLocation.longitude = [oakCoor[1] floatValue];
            OakMapperSODPlacemark *sodPlacemark = [[OakMapperSODPlacemark alloc] initWithCoordinate:oakLocation];
            [sodPlacemark setTheTitle:[oak objectForKey:@"title"]];
            [sodPlacemark setTheSubtitle:[oak objectForKey:@"pubDate"]];
            [sodPlacemark setDescription:[oak objectForKey:@"description"]];
            [sodPlacemark setSubmitType:geomType];
            // Get the image URL if there is one
            //[sodPlacemark setImageURL:[oak objectForKey:@"imageURL"]];
            
            [self performSelectorOnMainThread:@selector(addToMap:) withObject:sodPlacemark waitUntilDone:NO];
        }
	}
}
 */

- (IBAction)signin:(id)sender {
    
    // 1. validate the inupt fields: email and password
    // If it's not valid, display error message and tell user to retry
    NSString *email = [_emailTF text];
    NSString *password = [_passwordTF text];
    

    // 2. If successful, send email and password to server for login purpose

    // Generate coded password. For example, add salt to the front of the password or modify the password
    // [self transmit:[self encodePassword:password]];
    
    

    // If login fails, display error message about wrong username or password, try agaim.
    
    // 3. If login is sucessful, ceate the OakMapperUser singleton object
    
    // 4. Return back to home page
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
