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
		_cameraOverlayController.delegate = self;
		_firstLoad = YES;
	}
	return self;
}

#pragma mark - Overwritten methods

- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
	if (self.isFirstLoad) {
		self.firstLoad = NO;
		[UIApplication sharedApplication].statusBarHidden = YES;
		[self presentViewController:self.cameraOverlayController animated:NO completion:NULL];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - SVCameraOverlayControllerDelegate

- (void)cameraOverlayController:(SVCameraOverlayController *)controller didTakePicture:(UIImage *)image {
	if (!self.cameraPreviewController) {
		self.cameraPreviewController = [[SVCameraPreviewController alloc] init];
		self.cameraPreviewController.view.frame = self.view.bounds;
		[self.view addSubview:self.cameraPreviewController.view];
		self.cameraPreviewController.delegate = self;
	}
	[self.cameraPreviewController loadImage:image];
	[UIApplication sharedApplication].statusBarHidden = NO;
	[self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - SVCameraPreviewControllerDelegate

- (void)cameraPreviewControllerDidRetry:(SVCameraPreviewController *)controller {
	[self presentViewController:self.cameraOverlayController animated:YES completion:NULL];
}

- (void)cameraPreviewControllerDidSave:(SVCameraPreviewController *)controller {
	[self presentViewController:self.cameraOverlayController animated:YES completion:NULL];
}

@end
