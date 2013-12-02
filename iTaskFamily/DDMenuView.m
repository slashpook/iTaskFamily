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
    //On vérifie que l'on est pas déjà sur la page courante
    if (self.imageViewSelection.frame.origin.y != [(UIButton *)sender frame].origin.y)
    {
        //On lance les animations
        [self moveView:sender.frame andColor:COULEUR_HOME];
        [self.delegate openHomePage];
    }
}

//Switch on Player view
- (IBAction)onPushPlayerButton:(UIButton *)sender
{
    //On vérifie que l'on est pas déjà sur la page courante
    if (self.imageViewSelection.frame.origin.y != [(UIButton *)sender frame].origin.y)
    {
        //On récupère le sens de l'animation
        int sens = 1;
        if (self.imageViewSelection.frame.origin.y > [(UIButton *)sender frame].origin.y)
            sens = -1;

        //On lance les animations
        [self moveView:sender.frame andColor:COULEUR_PLAYER];
        [self.delegate openPlayerPageWithSens:sens];
    }
}

//Switch on Task view
- (IBAction)onPushTaskButton:(UIButton *)sender
{
    //On vérifie que l'on est pas déjà sur la page courante
    if (self.imageViewSelection.frame.origin.y != [(UIButton *)sender frame].origin.y)
    {
        //On récupère le sens de l'animation
        int sens = 1;
        if (self.imageViewSelection.frame.origin.y > [(UIButton *)sender frame].origin.y)
            sens = -1;

        //On lance les animations
        [self moveView:sender.frame andColor:COULEUR_TASK];
        [self.delegate openTaskPageWithSens:sens];
    }
}

//Switch on Trophy view
- (IBAction)onPushTrophyButton:(UIButton *)sender
{
    //On vérifie que l'on est pas déjà sur la page courante
    if (self.imageViewSelection.frame.origin.y != [(UIButton *)sender frame].origin.y)
    {
        //On récupère le sens de l'animation
        int sens = 1;
        if (self.imageViewSelection.frame.origin.y > [(UIButton *)sender frame].origin.y)
            sens = -1;

        //On lance les animations
        [self moveView:sender.frame andColor:COULEUR_TROPHY];
        [self.delegate openPodiumPageWithSens:sens];
    }
}

//Switch on Setting view
- (IBAction)onPushSettingButton:(UIButton *)sender
{
    //On vérifie que l'on est pas déjà sur la page courante
    if (self.imageViewSelection.frame.origin.y != [(UIButton *)sender frame].origin.y)
    {
        //On lance les animations
        [self moveView:sender.frame andColor:COULEUR_SETTING];
        [self.delegate openSettingPage];
    }
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
