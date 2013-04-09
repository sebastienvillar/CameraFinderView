//
//  SVCameraPreviewController.m
//  CameraViewFinder
//
//  Created by Sébastien Villar on 9/04/13.
//  Copyright (c) 2013 Sébastien Villar. All rights reserved.
//

#import "SVCameraPreviewController.h"
#import "SVTabView.h"

#define imageViewBorderWidth 5

@interface SVCameraPreviewController ()
@property (strong, readwrite) UIImageView* imageView;
@property (strong, readwrite) UIView* controlsView;
@property (strong, readwrite) UIButton* retryButton;
@property (strong, readwrite) UIButton* saveButton;
@property (strong, readwrite) UIImage* image;
@end

@implementation SVCameraPreviewController

- (id)init {
	self = [super init];
	if (self) {
	}
	return self;
}

- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.view.backgroundColor = [UIColor blackColor];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	self.imageView = [[UIImageView alloc] init];
	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
	self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
	self.controlsView = [[SVTabView alloc] init];
	self.controlsView.translatesAutoresizingMaskIntoConstraints = NO;
	UIImage* buttonImage = [[UIImage imageNamed:@"button.png"]
							resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 30)
							resizingMode:UIImageResizingModeTile];
	self.retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.retryButton setTitle:@"Retry" forState:UIControlStateNormal];
	[self.retryButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
	[self.retryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.retryButton addTarget:self action:@selector(retry) forControlEvents:UIControlEventTouchUpInside];
	self.retryButton.translatesAutoresizingMaskIntoConstraints = NO;
	
	self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
	[self.saveButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
	[self.saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
	self.saveButton.translatesAutoresizingMaskIntoConstraints = NO;
	
	self.controlsView.backgroundColor = [UIColor grayColor];
	[self.controlsView addSubview:self.retryButton];
	[self.controlsView addSubview:self.saveButton];
	[self.view addSubview:self.controlsView];
	[self.view addSubview:self.imageView];
	NSArray* objects = [NSArray arrayWithObjects:self.imageView, self.controlsView, self.retryButton, self.saveButton, nil];
	NSArray* keys = [NSArray arrayWithObjects:@"imageView", @"controlsView", @"retryButton", @"saveButton", nil];
	NSDictionary* views = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	NSArray* imageViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[imageView]-|"
																			options:0
																			metrics:nil views:views];
	NSArray* controlsViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[controlsView]|"
																			   options:0
																			   metrics:nil views:views];
	
	NSArray* buttonsHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[retryButton]-[saveButton]-10-|"
																			   options:0
																			   metrics:nil views:views];
	NSLayoutConstraint* buttonWidthConstraint = [NSLayoutConstraint constraintWithItem:self.retryButton
																			 attribute:NSLayoutAttributeWidth
																			 relatedBy:NSLayoutRelationEqual
																				toItem:self.saveButton
																			 attribute:NSLayoutAttributeWidth
																			multiplier:1.0
																			  constant:0.0];

	NSLayoutConstraint* retryCenterYConstraint = [NSLayoutConstraint constraintWithItem:self.retryButton
																			  attribute:NSLayoutAttributeCenterY
																				relatedBy:NSLayoutRelationEqual
																				   toItem:self.controlsView
																				attribute:NSLayoutAttributeCenterY
																			   multiplier:1.0
																				 constant:0.0];
	
	NSLayoutConstraint* saveCenterYConstraint = [NSLayoutConstraint constraintWithItem:self.saveButton
																			  attribute:NSLayoutAttributeCenterY
																			  relatedBy:NSLayoutRelationEqual
																				 toItem:self.controlsView
																			  attribute:NSLayoutAttributeCenterY
																			 multiplier:1.0
																			   constant:0.0];
	NSArray* overallConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]-[controlsView(70)]|"
																		  options:0
																		  metrics:nil
																			views:views];
	
	NSMutableArray* constraints = [NSMutableArray arrayWithArray:imageViewConstraints];
	[constraints addObjectsFromArray:controlsViewConstraints];
	[constraints addObjectsFromArray:buttonsHorizontalConstraints];
	[constraints addObject:buttonWidthConstraint];
	[constraints addObject:retryCenterYConstraint];
	[constraints addObject:saveCenterYConstraint];
	[constraints addObjectsFromArray:overallConstraints];
	
	[self.view addConstraints:constraints];
}

- (void)loadImage:(UIImage*)image {
	self.image = image;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.imageView.image = self.image;
}

- (void)retry {
	if (self.delegate && [self.delegate respondsToSelector:@selector(cameraPreviewControllerDidRetry:)]) {
		[self.delegate cameraPreviewControllerDidRetry:self];
	}
}

- (void)save {
	UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Saved"
														message:@"The image was saved in camera roll"
													   delegate:self
											  cancelButtonTitle:nil
											  otherButtonTitles:@"Ok",nil];
	[alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		if (self.delegate && [self.delegate respondsToSelector:@selector(cameraPreviewControllerDidSave:)]) {
			[self.delegate cameraPreviewControllerDidSave:self];
		}
	}
}

@end
