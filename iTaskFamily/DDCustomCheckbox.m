//
//  DDCustomCheckbox.m
//  iTaskFamily
//
//  Created by Damien DELES on 04/03/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDCustomCheckbox.h"

@implementation DDCustomCheckbox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    //// Color Declarations
    UIColor* vert = COULEUR_BORDER_CHECKBOX;
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(7.5, 6.5, 30, 31)];
    [[UIColor whiteColor] setFill];
    [ovalPath fill];
    [vert setStroke];
    ovalPath.lineWidth = 1;
    [ovalPath stroke];
    
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(11.5, 20.75)];
    [bezierPath addCurveToPoint: CGPointMake(21.03, 30.5) controlPoint1: CGPointMake(20.3, 29.75) controlPoint2: CGPointMake(21.03, 30.5)];
    [bezierPath addLineToPoint: CGPointMake(33.5, 15.5)];
    [[UIColor whiteColor] setFill];
    [bezierPath fill];
    [vert setStroke];
    bezierPath.lineWidth = 2;
    [bezierPath stroke];

}


@end
