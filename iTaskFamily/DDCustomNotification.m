//
//  DDCustomNotification.m
//  iTaskFamily
//
//  Created by Damien DELES on 12/03/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDCustomNotification.h"

@implementation DDCustomNotification

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setSize:25];
        
        _labelNumberNotification = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 25, 25)];
        [self.labelNumberNotification setTextAlignment:NSTextAlignmentCenter];
        [self.labelNumberNotification setTextColor:COULEUR_WHITE];
        [self.labelNumberNotification setFont:POLICE_NOTIFICATION];
        [self addSubview:self.labelNumberNotification];
    }
    return self;
}

//On fait un popIn de la notification
- (void)popIn
{
    //On supprime les éventuelles animations
    [[self layer] removeAllAnimations];
    
    //On rend la notif visible
    [self setHidden:NO];
    
    //On crée une animation basic pour changer l'échelle
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    [animation setDelegate:self];
    [animation setValue:@"popIn" forKey:@"id"];
    
    //On donne la durée de l'animation
    animation.duration = 0.40;
    
    //On précise les valeur que va prendre la propriété transform.scale
    animation.values = [NSArray arrayWithObjects:
                             [NSNumber numberWithFloat:0],
                             [NSNumber numberWithFloat:1.5],
                             [NSNumber numberWithFloat:0.80],
                             [NSNumber numberWithFloat:1],
                             nil];
    
    //On précise à quels moments les valeurs doivent être appliquées.
    animation.keyTimes = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0],
                          [NSNumber numberWithFloat:0.4],
                          [NSNumber numberWithFloat:0.7],
                          [NSNumber numberWithFloat:1.0],
                          nil];
    
    //On met que ça ne doit pas être consistent pour la fin de l'animation
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    
    //On change le style de l'animation (rapide puis normal)
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];

    //On ajoute l'animation
    [[self layer] addAnimation:animation forKey:@"scale"];
}

//On fait un popOut de la notification
- (void)popOut
{
    //On supprime les éventuelles animations
    [[self layer] removeAllAnimations];
    
    //On crée une animation basic pour changer l'échelle
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    [animation setDelegate:self];
    [animation setValue:@"popOut" forKey:@"id"];
    
    //On donne la durée de l'animation
    animation.duration = 0.30;
    
    //On précise les valeur que va prendre la propriété transform.scale
    animation.values = [NSArray arrayWithObjects:
                        [NSNumber numberWithFloat:1],
                        [NSNumber numberWithFloat:1.4],
                        [NSNumber numberWithFloat:0],
                        nil];
    
    //On précise à quels moments les valeurs doivent être appliquées.
    animation.keyTimes = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0],
                          [NSNumber numberWithFloat:0.5],
                          [NSNumber numberWithFloat:1.0],
                          nil];
    
    //On met que ça ne doit pas être consistent pour la fin de l'animation
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    
    //On change le style de l'animation (rapide puis normal)
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    //On ajoute l'animation
    [[self layer] addAnimation:animation forKey:@"scale"];
}

- (void)drawRect:(CGRect)rect
{
    [self setBackgroundColor:COULEUR_TRANSPARENT];
    
    //// Color Declarations
    UIColor* content = COULEUR_NOTIFICATION;
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(8, 8, 25, 25)];
    [content setFill];
    [ovalPath fill];
    [content setStroke];
    ovalPath.lineWidth = 0.5;
    [ovalPath stroke];
    
    //// Text Drawing
    [[self labelNumberNotification] setFrame:CGRectMake(8, 8, 25, 25)];
}


#pragma mark - Animation delegate functions

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
    //On cache l'animation si on fait un popOut
    if ([[animation valueForKey:@"id"] isEqualToString:@"popOut"])
        [self setHidden:YES];
    else
        [self setHidden:NO];
}

@end
