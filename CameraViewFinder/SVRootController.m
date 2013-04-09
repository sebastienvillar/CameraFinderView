//
//  SVRootController.m
//  CameraViewFinder
//
//  Created by Sébastien Villar on 9/04/13.
//  Copyright (c) 2013 Sébastien Villar. All rights reserved.
//

#import "SVRootController.h"

@interface SVRootController ()
@property (strong, readwrite) SVCameraOverlayController* cameraOverlayController;
@property (strong, readwrite) SVCameraPreviewController* cameraPreviewController;
@property (assign, readwrite, getter = isFirstLoad) BOOL firstLoad;
@end

@implementation SVRootController
@synthesize cameraOverlayController = _cameraOverlayController,
			cameraPreviewController = _cameraPreviewController,
			firstLoad = _firstLoad;

- (id)init {
	self = [super init];
	if (self) {
		_cameraOverlayController = [[SVCameraOverlayController alloc] init];
		_cameraPreviewController = [[SVCameraPreviewController alloc] init];
		_cameraOverlayController.delegate = self;
		_firstLoad = YES;
	}
	return self;
}

#pragma mark - Overwritten methods

- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.view.backgroundColor = [UIColor blackColor];
	[self.view addSubview:self.cameraPreviewController.view];
}

- (void)viewWillLayoutSubviews {
	self.cameraPreviewController.view.frame = self.view.bounds;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
	if (self.isFirstLoad) {
		self.firstLoad = NO;
		[self presentViewController:self.cameraOverlayController animated:NO completion:NULL];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - SVCameraOverlayControllerDelegate

- (void)cameraController:(SVCameraOverlayController *)controller didTakePicture:(UIImage *)image {
	[self.cameraPreviewController loadImage:image];
	[self dismissViewControllerAnimated:YES completion:NULL];
}

@end
