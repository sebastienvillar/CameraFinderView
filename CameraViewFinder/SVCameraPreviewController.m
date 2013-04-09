//
//  SVCameraPreviewController.m
//  CameraViewFinder
//
//  Created by Sébastien Villar on 9/04/13.
//  Copyright (c) 2013 Sébastien Villar. All rights reserved.
//

#import "SVCameraPreviewController.h"

#define imageViewBorderWidth 5

@interface SVCameraPreviewController ()
@property (strong, readwrite) UIImageView* imageView;
@end

@implementation SVCameraPreviewController
@synthesize imageView = _imageView;

- (id)init {
	self = [super init];
	if (self) {
		_imageView = [[UIImageView alloc] init];
		_imageView.contentMode = UIViewContentModeScaleAspectFit;
	}
	return self;
}

- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.view.backgroundColor = [UIColor blackColor];
	[self.view addSubview:self.imageView];
}

- (void)loadImage:(UIImage*)image {
	self.imageView.image = image;
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	self.imageView.frame = self.view.bounds;
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
