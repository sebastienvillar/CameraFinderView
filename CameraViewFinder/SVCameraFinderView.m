//
//  SVCameraFinderView.m
//  CameraViewFinder
//
//  Created by Sébastien Villar on 9/04/13.
//  Copyright (c) 2013 Sébastien Villar. All rights reserved.
//

#import "SVCameraFinderView.h"

@implementation SVCameraFinderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
	UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, 5, 5) cornerRadius:10];
	path.lineWidth = 5;
	[[UIColor colorWithWhite:1.0 alpha:0.5] setStroke];
	[path stroke];
}


@end
