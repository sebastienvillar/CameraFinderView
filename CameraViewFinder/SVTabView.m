//
//  SVTabView.m
//  CameraViewFinder
//
//  Created by Sébastien Villar on 9/04/13.
//  Copyright (c) 2013 Sébastien Villar. All rights reserved.
//

#import "SVTabView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SVTabView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		CALayer* layer = self.layer;
		layer.shadowColor = [UIColor blackColor].CGColor;
		layer.shadowOpacity = 1.0;
		layer.shadowRadius = 3.0;
		layer.shadowOffset = CGSizeMake(0, 0);
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0, 1.0};
	
	UIColor* topColor = [UIColor colorWithRed:0.281 green:0.281 blue:0.281 alpha:1.0000];
	UIColor* bottomColor = [UIColor blackColor];
    NSArray *colors = [NSArray arrayWithObjects:(id)topColor.CGColor, (id)bottomColor.CGColor, nil];
	
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
	
	CGContextSaveGState(context);
	CGContextAddRect(context, self.bounds);
	CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, self.frame.size.height), 0);
	CGContextRestoreGState(context);
	
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorSpace);
}


@end
