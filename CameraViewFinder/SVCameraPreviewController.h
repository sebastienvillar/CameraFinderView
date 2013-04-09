//
//  SVCameraPreviewController.h
//  CameraViewFinder
//
//  Created by Sébastien Villar on 9/04/13.
//  Copyright (c) 2013 Sébastien Villar. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVCameraPreviewController;

@protocol SVCameraPreviewControllerDelegate <NSObject>
- (void)cameraPreviewControllerDidRetry:(SVCameraPreviewController*)controller;
- (void)cameraPreviewControllerDidSave:(SVCameraPreviewController*)controller;
@end

@interface SVCameraPreviewController : UIViewController <UIAlertViewDelegate>
@property (weak, readwrite) id delegate;
- (void)loadImage:(UIImage*)image;
@end
