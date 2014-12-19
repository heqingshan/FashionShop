//
//  LeftDemoViewController.m
//  PKRevealController
//
//  Created by Philip Kluz on 1/18/13.
//  Copyright (c) 2013 zuui.org. All rights reserved.
//

#import "LeftDemoViewController.h"
#import "PKRevealController.h"

@implementation LeftDemoViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Each view can dynamically specify the min/max width that can be revealed.
    [self.revealController setMinimumWidth:280.0f maximumWidth:324.0f forViewController:self];
}

#pragma mark - API

- (IBAction)showOppositeView:(id)sender
{
    /*
  //  [self.revealController showViewController:self.revealController.rightViewController];
    
    FSSettingViewController *controller = [[FSSettingViewController alloc] initWithNibName:@"FSSettingViewController" bundle:nil];
    controller.isFromSideView = YES;
    //controller.currentUser = _userProfile;
    //controller.delegate = self;
    //[self.navigationController pushViewController:controller animated:YES];
//    self.revealController.frontViewController = controller;
//    [self.revealController showViewController:controller animated:YES completion:^(BOOL finished) {
//        [controller.navigationController setNavigationBarHidden:NO];
//    }];
    
    self.revealController.frontViewController = controller;//[[UINavigationController alloc] initWithRootViewController:controller];
    [self.revealController showViewController:self.revealController.frontViewController animated:YES completion:nil];
     */
}

- (IBAction)togglePresentationMode:(id)sender
{
    if (![self.revealController isPresentationModeActive])
    {
        [self.revealController enterPresentationModeAnimated:YES
                                                  completion:NULL];
    }
    else
    {
        [self.revealController resignPresentationModeEntirely:NO
                                                     animated:YES
                                                   completion:NULL];
    }
}

#pragma mark - Autorotation

/*
* Please get familiar with iOS 6 new rotation handling as if you were to nest this controller within a UINavigationController,
* the UINavigationController would _NOT_ relay rotation requests to his children on its own!
*/

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end