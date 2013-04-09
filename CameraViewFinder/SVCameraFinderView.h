//
//  SVCameraFinderView.h
//  CameraViewFinder
//
//  Created by Sébastien Villar on 9/04/13.
//  Copyright (c) 2013 Sébastien Villar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVClearBoxView.h"

@interface SVCameraFinderView : UIView
@property (strong, readonly) SVClearBoxView* clearBoxView;
@property (assign, readwrite, getter = isAnimating) BOOL animating;
@end
