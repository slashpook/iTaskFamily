//
//  DDCustomButton.m
//  iTaskFamily
//
//  Created by Damien DELES on 16/05/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDCustomButton.h"

@implementation DDCustomButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setColorTitleEnable:COULEUR_HOME];
        [self setColorTitleDisable:COULEUR_DISABLED];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //// Title Color
    [self setTitleColor:self.colorTitleEnable forState:UIControlStateNormal];
    [self setTitleColor:self.colorTitleDisable forState:UIControlStateDisabled];
    
    //// Color Declarations
    UIColor* strokeColor = (self.enabled ? self.colorTitleEnable : self.colorTitleDisable);
    
    //// Frames
    CGRect frame = rect;
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPath];
    [roundedRectanglePath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 1, CGRectGetMaxY(frame) - 6)];
    [roundedRectanglePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 6, CGRectGetMaxY(frame) - 1) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 1, CGRectGetMaxY(frame) - 3.24) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 3.24, CGRectGetMaxY(frame) - 1)];
    [roundedRectanglePath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 6, CGRectGetMaxY(frame) - 1)];
    [roundedRectanglePath addCurveToPoint: CGPointMake(CGRectGetMaxX(frame) - 1, CGRectGetMaxY(frame) - 6) controlPoint1: CGPointMake(CGRectGetMaxX(frame) - 3.24, CGRectGetMaxY(frame) - 1) controlPoint2: CGPointMake(CGRectGetMaxX(frame) - 1, CGRectGetMaxY(frame) - 3.24)];
    [roundedRectanglePath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 1, CGRectGetMinY(frame) + 6)];
    [roundedRectanglePath addCurveToPoint: CGPointMake(CGRectGetMaxX(frame) - 6, CGRectGetMinY(frame) + 1) controlPoint1: CGPointMake(CGRectGetMaxX(frame) - 1, CGRectGetMinY(frame) + 3.24) controlPoint2: CGPointMake(CGRectGetMaxX(frame) - 3.24, CGRectGetMinY(frame) + 1)];
    [roundedRectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 6, CGRectGetMinY(frame) + 1)];
    [roundedRectanglePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 1, CGRectGetMinY(frame) + 6) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 3.24, CGRectGetMinY(frame) + 1) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 1, CGRectGetMinY(frame) + 3.24)];
    [roundedRectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 1, CGRectGetMaxY(frame) - 6)];
    [roundedRectanglePath closePath];
    [strokeColor setStroke];
    roundedRectanglePath.lineWidth = 1;
    [roundedRectanglePath stroke];
    
}

@end
