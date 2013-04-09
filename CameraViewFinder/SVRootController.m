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


- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	[self.view addSubview:self.childNavigationController.view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
