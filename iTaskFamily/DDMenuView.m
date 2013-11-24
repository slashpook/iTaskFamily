//
//  DDMenuView.m
//  iTaskFamily
//
//  Created by Damien DELES on 20/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDMenuView.h"

@implementation DDMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    //On set le fond du menu
    [self setBackgroundColor:COULEUR_BLACK];
    
    //On enlève le toucher multiple sur le menu
    [self.subviews makeObjectsPerformSelector:@selector(setExclusiveTouch:) withObject:[NSNumber numberWithBool:YES]];
}


#pragma mark - View fonctions

//Switch on Home view
- (IBAction)onPushHomeButton:(UIButton *)sender
{
    [self moveView:sender.frame andColor:COULEUR_HOME];
}

//Switch on Player view
- (IBAction)onPushPlayerButton:(UIButton *)sender
{
    [self moveView:sender.frame andColor:COULEUR_PLAYER];
}

//Switch on Task view
- (IBAction)onPushTaskButton:(UIButton *)sender
{
    [self moveView:sender.frame andColor:COULEUR_TASK];
}

//Switch on Trophy view
- (IBAction)onPushTrophyButton:(UIButton *)sender
{
    [self moveView:sender.frame andColor:COULEUR_TROPHY];
}

//Switch on Setting view
- (IBAction)onPushSettingButton:(UIButton *)sender
{
    [self moveView:sender.frame andColor:COULEUR_SETTING];
}

//On bouge la vue qui sélectionne la page
- (void)moveView:(CGRect)location andColor:(UIColor *)color
{
    //Lance l'animation et change la couleur en fonction du bouton sélectionné
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.imageViewSelection setFrame:location];
        [self.imageViewSelection setBackgroundColor:color];
        [self.imageViewLeftBar setBackgroundColor:color];
    } completion:nil];
}

@end
