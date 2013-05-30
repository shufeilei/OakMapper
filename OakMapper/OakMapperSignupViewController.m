//
//  OakMapperSignupViewController.m
//  OakMapper
//
//  Created by Shufei Lei on 5/4/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

#import "OakMapperSignupViewController.h"

@interface OakMapperSignupViewController ()

@end

@implementation OakMapperSignupViewController

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

- (IBAction)selectBackground:(id)sender {
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Background" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"None" otherButtonTitles:@"Academic", @"Government", @"Public", nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (![buttonTitle isEqualToString:@"Cancel"]) {
        [_selectBkgButton setTitle:buttonTitle forState:UIControlStateNormal];
    }
    
}

- (IBAction)cancelSignup:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
