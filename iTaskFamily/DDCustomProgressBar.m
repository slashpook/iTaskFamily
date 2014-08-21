//
//  DDCustomProgressBar.m
//  iTaskFamily
//
//  Created by Damien DELES on 05/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDCustomProgressBar.h"

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
    
    if (self.category == nil)
    {
        //On récupère le nombre de fois qu'on a réalisé la tache
        int countOfTaskRealized = 0;
        if (self.player != nil)
            [[DDDatabaseAccess instance] getNumberOfEventCheckedForPlayer:self.player forTask:self.trophy.task];
        
        //Si on a un début de progression
        if (countOfTaskRealized != 0)
        {
            //Si on a réalisé plus que ne le demande le trophy, on met le count au total
            if (countOfTaskRealized > [self.trophy.iteration intValue])
                countOfTaskRealized = [self.trophy.iteration intValue];
            
            float progression = countOfTaskRealized / [self.trophy.iteration floatValue];
            UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, self.frame.size.width * progression, self.frame.size.height) cornerRadius:5.0];
            [self.colorRealisation setFill];
            [roundedRectanglePath fill];
        }
    }
    else
    {
        //On récupère le nombre de fois qu'on a réalisé la tache
        int countOfTaskRealized = [[DDDatabaseAccess instance] getNumberOfTrophyAchievedForPlayer:self.player inCategory:self.category andType:self.typeTrophy];
        
        //Si on a un début de progression
        if (countOfTaskRealized != 0)
        {
            float progression = countOfTaskRealized / [[[DDDatabaseAccess instance] getTasksForCategory:self.category] count];
            UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, self.frame.size.width * progression, self.frame.size.height) cornerRadius:5.0];
            [self.colorRealisation setFill];
            [roundedRectanglePath fill];
        }
    }
    
    CGContextSaveGState(context);
    CGContextRestoreGState(context);
}

@end
