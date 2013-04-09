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
@property (strong, readwrite) UIView* controlsView;
@property (strong, readwrite) UIButton* retryButton;
@property (strong, readwrite) UIButton* saveButton;
@end

@implementation SVCameraPreviewController
@synthesize imageView = _imageView,
			controlsView = _controlsView,
			retryButton = _retryButton,
			saveButton = _saveButton;

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
	self.controlsView = [[UIView alloc] init];
	self.retryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self.retryButton setTitle:@"Retry" forState:UIControlStateNormal];
	[self.retryButton addTarget:self action:@selector(retry) forControlEvents:UIControlEventTouchUpInside];
	
	self.saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self.saveButton setTitle:@"Save to camera roll" forState:UIControlStateNormal];
	[self.saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
	
	self.controlsView.backgroundColor = [UIColor grayColor];
	[self.controlsView addSubview:self.retryButton];
	[self.controlsView addSubview:self.saveButton];
	[self.view addSubview:self.controlsView];
	[self.view addSubview:self.imageView];
}

- (void)loadImage:(UIImage*)image {
	self.imageView.image = image;
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	CGSize boundsSize = self.view.bounds.size;
	CGSize controlsViewSize = CGSizeMake(boundsSize.width, 80);
	self.imageView.frame = CGRectMake(0, 0,
									  boundsSize.width,
									  boundsSize.height - controlsViewSize.height);
	self.controlsView.frame = CGRectMake(0,
										 self.imageView.frame.size.height,
										 controlsViewSize.width,
										 controlsViewSize.height);
	
	CGSize retryButtonSize = CGSizeMake(80, 50);
	CGSize saveButtonSize = CGSizeMake(160, 50);

	self.retryButton.frame = CGRectMake(25, controlsViewSize.height/2 - retryButtonSize.height/2,
										retryButtonSize.width, retryButtonSize.height);
	self.saveButton.frame = CGRectMake(controlsViewSize.width - saveButtonSize.width - 25,
										controlsViewSize.height/2 - saveButtonSize.height/2,
										saveButtonSize.width, saveButtonSize.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)retry {
	if (self.delegate && [self.delegate respondsToSelector:@selector(cameraPreviewControllerDidRetry:)]) {
		[self.delegate cameraPreviewControllerDidRetry:self];
	}
}

- (void)save {
	UIImageWriteToSavedPhotosAlbum(self.imageView.image, nil, nil, nil);
	if (self.delegate && [self.delegate respondsToSelector:@selector(cameraPreviewControllerDidSave:)]) {
		[self.delegate cameraPreviewControllerDidSave:self];
	}
}

@end
