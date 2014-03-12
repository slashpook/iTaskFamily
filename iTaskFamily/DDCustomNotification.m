//
//  DDCustomNotification.m
//  iTaskFamily
//
//  Created by Damien DELES on 12/03/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDCustomNotification.h"

@implementation DDCustomNotification

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self setBackgroundColor:COULEUR_TRANSPARENT];

    //// Color Declarations
    UIColor* content = [UIColor colorWithRed: 0.906 green: 0.298 blue: 0.235 alpha: 1];
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, 25, 25)];
    [content setFill];
    [ovalPath fill];
    [content setStroke];
    ovalPath.lineWidth = 0.5;
    [ovalPath stroke];
    
    
    //// Text Drawing
    CGRect textRect = CGRectMake(0, 4, 24, 17);
    NSMutableParagraphStyle* textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    [textStyle setAlignment: NSTextAlignmentCenter];
    
    NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica-Light" size: 14], NSForegroundColorAttributeName: [UIColor whiteColor], NSParagraphStyleAttributeName: textStyle};
    
    [@"16" drawInRect: textRect withAttributes: textFontAttributes];
}

@end
