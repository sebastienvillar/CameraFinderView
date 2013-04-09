//
//  SVCameraOverlayController.m
//  CameraViewFinder
//
//  Created by Sébastien Villar on 9/04/13.
//  Copyright (c) 2013 Sébastien Villar. All rights reserved.
//

#import "SVCameraOverlayController.h"
#import "SVCameraFinderView.h"
#import <MobileCoreServices/MobileCoreServices.h>


#define cameraControlHeight568 76
#define cameraFinderBorderWidth 10
#define cameraFinderWidthToHeightRatio 1.586


@interface SVCameraOverlayController ()
@property (strong, readwrite) UIImagePickerController* imagePickerController;
@property (strong, readwrite) SVCameraFinderView* cameraFinderView;
@property (strong, readwrite) UIView* overlayView;
@property (strong, readwrite) UIView* overlayControlsView;
@property (strong, readwrite) UIButton* takePictureButton;
@end

@implementation SVCameraOverlayController
@synthesize imagePickerController = _imagePickerController,
			cameraFinderView = _cameraFinderView,
			overlayView = _overlayView,
			overlayControlsView = _overlayControlsView;

- (id)init {
	self = [super init];
	if (self) {
		_imagePickerController = [[UIImagePickerController alloc] init];
		[self configureImagePicker];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(orientationDidChange)
													 name:@"UIDeviceOrientationDidChangeNotification"
												   object:nil];
	}
	return self;
}

- (void)orientationDidChange {
	//Check device orientation because presented controller catches the orientation events
	UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
	if (!UIDeviceOrientationIsValidInterfaceOrientation(orientation)) {
		return;
	}
	CGRect bounds = self.overlayView.bounds;
	
	//Resize cameraFinder view
	[UIView animateWithDuration:0.3 animations:^{
		if (UIDeviceOrientationIsLandscape(orientation)) {
			CGSize cameraFinderSize = CGSizeMake((bounds.size.height - (cameraFinderBorderWidth * 2) - cameraControlHeight568) / cameraFinderWidthToHeightRatio,
												 (bounds.size.height - cameraFinderBorderWidth * 2) - cameraControlHeight568);
			
			self.cameraFinderView.frame = CGRectMake((bounds.size.width)/2 - cameraFinderSize.width/2,
													 cameraFinderBorderWidth,
													 cameraFinderSize.width,
													 cameraFinderSize.height);
		}
		else {
			CGSize cameraFinderSize = CGSizeMake(bounds.size.width - cameraFinderBorderWidth * 2,
												 (bounds.size.width - cameraFinderBorderWidth * 2) / cameraFinderWidthToHeightRatio);
			
			self.cameraFinderView.frame = CGRectMake(cameraFinderBorderWidth,
													 (bounds.size.height - cameraControlHeight568)/2 - cameraFinderSize.height/2,
													 cameraFinderSize.width,
													 cameraFinderSize.height);
		}
	}];
}

//Return YES if the device is supports the camera. NO otherwise
//If YES, configure the imagePickerController
- (BOOL)configureImagePicker {
	if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		return NO;
	}
	NSArray* mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
	bool isAvailable = NO;
	for (int i = 0; i < mediaTypes.count; i++) {
		CFStringRef mediaType = (__bridge CFStringRef)([mediaTypes objectAtIndex:i]);
		if (CFStringCompare(mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
			isAvailable = YES;
		}
	}
	if (!isAvailable) {
		return NO;
	}
	self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
	self.imagePickerController.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeImage];
	self.imagePickerController.showsCameraControls = NO;
	self.imagePickerController.delegate = self;
	return YES;
}

- (UIImage*)croppedImageToFinder:(UIImage*)image {
	CGRect finderRect = self.cameraFinderView.frame;
	finderRect.size.width -= 2 * innerBorder;
	finderRect.size.height -= 2 * innerBorder;
	float ratio;
	if (image.size.height > image.size.width) {
		ratio = image.size.height / (self.overlayView.frame.size.height - cameraControlHeight568);
	}
	else {
		ratio = image.size.width / (self.overlayView.frame.size.height - cameraControlHeight568);
		finderRect = CGRectMake(CGRectGetMinX(finderRect),
								CGRectGetMinY(finderRect),
								finderRect.size.height,
								finderRect.size.width);
	}
	CGPoint imageCenter = CGPointMake(image.size.width/2, image.size.height/2);
	
	//Create a new rect to match the real photo size
	CGRect realFinderRect = CGRectMake(imageCenter.x - (CGRectGetWidth(finderRect)/2 * ratio),
									   imageCenter.y - (CGRectGetHeight(finderRect)/2 * ratio),
									   CGRectGetWidth(finderRect) * ratio,
									   CGRectGetHeight(finderRect) * ratio);
	UIBezierPath* translatedFinderBezier = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0,
																							  CGRectGetWidth(realFinderRect),
																							  CGRectGetHeight(realFinderRect))
																	  cornerRadius:finderCornerRadius * ratio];
	UIGraphicsBeginImageContext(realFinderRect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	[[UIColor blackColor] setFill];
	CGContextFillRect(context, CGRectMake(0, 0, image.size.width, image.size.height));
	[translatedFinderBezier addClip];
	[image drawAtPoint:CGPointMake(-CGRectGetMinX(realFinderRect), -CGRectGetMinY(realFinderRect))];
	UIImage* croppedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	UIImageWriteToSavedPhotosAlbum(croppedImage, nil, nil, nil);
	return croppedImage;
}

#pragma mark - Overwritten methods

//Hack to hide the overlay during the shutter animation
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!viewController)
        return;
	
    UIView* controllerCameraView = [[viewController.view subviews] objectAtIndex:0];
    UIView* controllerPreview = [[viewController.view subviews] objectAtIndex:0];
    [controllerCameraView insertSubview:self.overlayView aboveSubview:controllerPreview];
}

- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.view.backgroundColor = [UIColor blackColor];
	self.overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
	self.overlayControlsView = [[UIView alloc] initWithFrame:CGRectMake(0,
																	   self.overlayView.frame.size.height - cameraControlHeight568,
																	   self.overlayView.frame.size.width,
																	   cameraControlHeight568)];
	self.cameraFinderView = [[SVCameraFinderView alloc] init];
	self.takePictureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self.takePictureButton setTitle:@"Take Picture" forState:UIControlStateNormal];
	[self.takePictureButton addTarget:self.imagePickerController
							   action:@selector(takePicture)
					 forControlEvents:UIControlEventTouchUpInside];
	
	[self.overlayControlsView addSubview:self.takePictureButton];
	[self.overlayView addSubview:self.overlayControlsView];
	self.overlayControlsView.backgroundColor = [UIColor grayColor];
	[self.overlayView addSubview:self.cameraFinderView];
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	CGRect bounds = self.overlayView.bounds;
	CGRect controlsBounds = self.overlayControlsView.bounds;
	CGSize buttonSize = CGSizeMake(125, 50);
	UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;

	//Set the cameraFinderView's frame according to the device orientation
	if (UIDeviceOrientationIsPortrait(orientation)) {
		CGSize cameraFinderSize = CGSizeMake(bounds.size.width - cameraFinderBorderWidth * 2,
											 (bounds.size.width - cameraFinderBorderWidth * 2) / cameraFinderWidthToHeightRatio);
		
		self.cameraFinderView.frame = CGRectMake(cameraFinderBorderWidth,
												 (bounds.size.height - cameraControlHeight568)/2 - cameraFinderSize.height/2,
												 cameraFinderSize.width,
												 cameraFinderSize.height);
	}
	else {
		CGSize cameraFinderSize = CGSizeMake(bounds.size.width - cameraFinderBorderWidth * 2,
											 (bounds.size.width - cameraFinderBorderWidth * 2) / cameraFinderWidthToHeightRatio);
		
		self.cameraFinderView.frame = CGRectMake(cameraFinderBorderWidth,
												 (bounds.size.height - cameraControlHeight568)/2 - cameraFinderSize.height/2,
												 cameraFinderSize.width,
												 cameraFinderSize.height);
	}
	
	self.takePictureButton.frame = CGRectMake(controlsBounds.size.width/2 - buttonSize.width/2,
											  controlsBounds.size.height/2 - buttonSize.height/2,
											  buttonSize.width,
											  buttonSize.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
	[self viewWillLayoutSubviews];
	[self presentViewController:self.imagePickerController animated:NO completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage* originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	UIImage* croppedImage = [self croppedImageToFinder:originalImage];
	if (self.delegate && [self.delegate respondsToSelector:@selector(cameraController:didTakePicture:)]) {
		[self.delegate cameraController:self didTakePicture:croppedImage];
	}
}

@end
