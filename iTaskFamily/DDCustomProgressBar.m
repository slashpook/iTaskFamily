//
//  DDCustomProgressBar.m
//  iTaskFamily
//
//  Created by Damien DELES on 05/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDCustomProgressBar.h"
#import "Realisation.h"

@implementation DDCustomProgressBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Color Declarations
    if (self.colorBackground == nil)
    {
        self.colorBackground = COULEUR_BLACK;
        self.colorRealisation = COULEUR_BLACK;
    }
    
    //Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) cornerRadius:5.0];
    [self.colorBackground setFill];
    [rectanglePath fill];
    
    //Progression
    if ( [self.realisation.realized floatValue] != 0)
    {
        float progression = [self.realisation.realized floatValue] / [self.realisation.total floatValue];
        UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, self.frame.size.width * progression, self.frame.size.height) cornerRadius:5.0];
        [self.colorRealisation setFill];
        [roundedRectanglePath fill];
    }
    
    CGContextSaveGState(context);
    CGContextRestoreGState(context);
}

@end
