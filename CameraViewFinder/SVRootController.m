//
//  SVRootController.m
//  CameraViewFinder
//
//  Created by Sébastien Villar on 9/04/13.
//  Copyright (c) 2013 Sébastien Villar. All rights reserved.
//

#import "SVRootController.h"
#import "SVCameraOverlayController.h"

@interface SVRootController ()
@property (strong, readwrite) SVCameraOverlayController* cameraOverlayController;
@property (strong, readwrite) UINavigationController* childNavigationController;
@end

@implementation SVRootController
@synthesize cameraOverlayController = _cameraOverlayController,
			childNavigationController = _childNavigationController;

- (id)init {
	self = [super init];
	if (self) {
		_cameraOverlayController = [[SVCameraOverlayController alloc] init];
		_childNavigationController = [[UINavigationController alloc] initWithRootViewController:_cameraOverlayController];
		_childNavigationController.navigationBarHidden = YES;
	}
	return self;
}

- (void)loadViewController:(UIViewController*)controller {
	[self addChildViewController:controller];
	controller.view.frame = self.view.frame;
	[self.view addSubview:controller.view];
	[controller didMoveToParentViewController:self];
}

#pragma mark - Overwritten methods

- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self loadViewController:self.childNavigationController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSUInteger)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskPortrait;
}

@end
