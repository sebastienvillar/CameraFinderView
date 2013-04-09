//
//  SVCameraFinderView.m
//  CameraViewFinder
//
//  Created by Sébastien Villar on 9/04/13.
//  Copyright (c) 2013 Sébastien Villar. All rights reserved.
//

#import "SVCameraFinderView.h"
#import "SVClearBoxView.h"
#import <QuartzCore/QuartzCore.h>

@interface SVCameraFinderView ()
@property (strong, readwrite) SVClearBoxView* clearBoxView;
@property (strong, readwrite) CADisplayLink* timer;
@end

@implementation SVCameraFinderView
@synthesize clearBoxView = _clearBoxView,
			animating = _animating;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		_animating = NO;
		self.backgroundColor = [UIColor clearColor];
		_clearBoxView = [[SVClearBoxView alloc] init];
		[self addSubview:_clearBoxView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGRect frame = self.clearBoxView.frame;
	if (self.isAnimating) {
		CALayer* layer = (CALayer*)self.clearBoxView.layer.presentationLayer;
		frame = layer.frame;
	}
	CGMutablePathRef outerPath = CGPathCreateMutable();
	CGPathAddRect(outerPath, NULL, self.bounds);
	UIBezierPath* clearPath = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:finderCornerRadius];
	CGPathAddPath(outerPath, NULL, clearPath.CGPath);
	[[UIColor colorWithWhite:0.0 alpha:0.8] setFill];
	CGContextAddPath(context, outerPath);
	CGContextEOFillPath(context);
}

- (void)setAnimating:(BOOL)animating {
	if (animating) {
		//Add a "frame timer" to draw when the frame changes.
		//Probably not the best way to do it
		self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
		self.timer.frameInterval = 1;
		[self.timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	}
	else {
		[self.timer invalidate];
	}
	_animating = animating;
}

- (BOOL)isAnimating {
	return _animating;
}

- (void)dealloc {
	[self removeObserver:self forKeyPath:@"frame"];
}

@end
