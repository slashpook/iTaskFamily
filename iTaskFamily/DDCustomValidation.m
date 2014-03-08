//
//  DDCustomValidation.m
//  iTaskFamily
//
//  Created by Damien DELES on 08/03/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDCustomValidation.h"

@implementation DDCustomValidation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setColorValidation:COULEUR_HOME];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //On défini les couleurs
    [self setBackgroundColor:[UIColor clearColor]];
    UIColor* fill = COULEUR_WHITE;
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(10.5, 21.52)];
    [bezierPath addCurveToPoint: CGPointMake(18.62, 29.53) controlPoint1: CGPointMake(19.25, 30.77) controlPoint2: CGPointMake(18.62, 29.53)];
    [bezierPath addLineToPoint: CGPointMake(30.5, 13.5)];
    [fill setFill];
    [bezierPath fill];
    [self.colorValidation setStroke];
    bezierPath.lineWidth = 2;
    [bezierPath stroke];
}


@end
