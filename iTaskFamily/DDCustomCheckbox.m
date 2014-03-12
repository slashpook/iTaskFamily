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
    UIColor *fill = COULEUR_BORDER_CHECKBOX;
    UIColor *border = COULEUR_WHITE;
    UIColor *check = COULEUR_CHECKBOX;
    
    if (self.isSelected)
    {
        fill = COULEUR_WHITE;
        border = COULEUR_BORDER_CHECKBOX;
    }
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(6, 6, 30, 30) cornerRadius: 7];
    [fill setFill];
    [roundedRectanglePath fill];
    [border setStroke];
    roundedRectanglePath.lineWidth = 1;
    [roundedRectanglePath stroke];
    
    if (self.isChecked == YES)
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(10.5, 21.52)];
        [bezierPath addCurveToPoint: CGPointMake(18.62, 29.53) controlPoint1: CGPointMake(19.25, 30.77) controlPoint2: CGPointMake(18.62, 29.53)];
        [bezierPath addLineToPoint: CGPointMake(30.5, 13.5)];
        [fill setFill];
        [bezierPath fill];
        [check setStroke];
        bezierPath.lineWidth = 2;
        [bezierPath stroke];
    }
}


@end
