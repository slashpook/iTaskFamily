//
//  DDHistogramView.m
//  iTaskFamily
//
//  Created by Damien DELES on 31/01/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDHistogramView.h"

@implementation DDHistogramView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    //Couleur de base
    [self setColorView:COULEUR_BLEU];
}

- (void)drawRect:(CGRect)rect
{
    ////Rounded Rectangle Drawing
    UIBezierPath *roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: CGSizeMake(10, 10)];
    [roundedRectanglePath closePath];
    [self.colorView setFill];
    [roundedRectanglePath fill];
}

@end
