//
//  SVCameraOverlayController.h
//  CameraViewFinder
//
//  Created by Sébastien Villar on 9/04/13.
//  Copyright (c) 2013 Sébastien Villar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SVCameraOverlayController;

@protocol SVCameraOverlayControllerDelegate <NSObject>
- (void)cameraOverlayController:(SVCameraOverlayController*)controller didTakePicture:(UIImage*)image;
@end

@interface SVCameraOverlayController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, readwrite) id delegate;
@end
