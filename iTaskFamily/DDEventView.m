//
//  DDEventView.m
//  iTaskFamily
//
//  Created by Damien DELES on 24/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDEventView.h"

@implementation DDEventView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    //On dessine la vue
    [self.layer setCornerRadius:10.0];
    [self.layer setMasksToBounds:YES];
    
    //On configure les polices et couleur des boutons et labels
    [self.labelNoPlayer setTextColor:COULEUR_BLACK];
    [self.labelNoPlayer setFont:POLICE_EVENT_NO_PLAYER];
    [[self.buttonLundi titleLabel] setTextColor:COULEUR_WHITE];
    [[self.buttonLundi titleLabel] setFont:POLICE_EVENT_DAY];
    [[self.buttonMardi titleLabel] setTextColor:COULEUR_WHITE];
    [[self.buttonMardi titleLabel] setFont:POLICE_EVENT_DAY];
    [[self.buttonMercredi titleLabel] setTextColor:COULEUR_WHITE];
    [[self.buttonMercredi titleLabel] setFont:POLICE_EVENT_DAY];
    [[self.buttonJeudi titleLabel] setTextColor:COULEUR_WHITE];
    [[self.buttonJeudi titleLabel] setFont:POLICE_EVENT_DAY];
    [[self.buttonVendredi titleLabel] setTextColor:COULEUR_WHITE];
    [[self.buttonVendredi titleLabel] setFont:POLICE_EVENT_DAY];
    [[self.buttonSamedi titleLabel] setTextColor:COULEUR_WHITE];
    [[self.buttonSamedi titleLabel] setFont:POLICE_EVENT_DAY];
    [[self.buttonDimanche titleLabel] setTextColor:COULEUR_WHITE];
    [[self.buttonDimanche titleLabel] setFont:POLICE_EVENT_DAY];
    
    //On met les images en couleurs
    [self.imageViewHeader setBackgroundColor:COULEUR_BLACK];
}


#pragma mark - View fonctions

//On appuie sur un des boutons
- (IBAction)onPushDayButton:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.imageViewSelection setFrame:[(UIButton *)sender frame]];
    }];
}

@end
