//
//  SVCameraOverlayController.m
//  CameraViewFinder
//
//  Created by Sébastien Villar on 9/04/13.
//  Copyright (c) 2013 Sébastien Villar. All rights reserved.
//

#import "SVCameraOverlayController.h"

@interface SVCameraOverlayController ()
@property (strong, readwrite) UIImagePickerController* imagePickerController;
@end

@implementation SVCameraOverlayController
@synthesize imagePickerController = _imagePickerController;

- (id)init {
	self = [super init];
	if (self) {
		_imagePickerController = [[UIImagePickerController alloc] init];
	}
	return self;
}

- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
	[self presentViewController:self.imagePickerController animated:NO completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
