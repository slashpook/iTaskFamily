//
//  DDDateView.m
//  iTaskFamily
//
//  Created by Damien DELES on 21/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDDateView.h"

@implementation DDDateView

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
    
    //On set la police et la couleur des labels
    [self.labelDay setFont:POLICE_HEADER];
    [self.labelDay setTextColor:COULEUR_WHITE];
    [self.labelNumberOfDay setFont:POLICE_DATE_BIG];
    [self.labelNumberOfDay setTextColor:COULEUR_BLACK];
    [self.labelMonth setFont:POLICE_DATE_MEDIUM];
    [self.labelMonth setTextColor:COULEUR_BLACK];
    [self.labelYear setFont:POLICE_DATE_MEDIUM];
    [self.labelYear setTextColor:COULEUR_BLACK];
    [self.labelHour setFont:POLICE_DATE_BIG];
    [self.labelHour setTextColor:COULEUR_BLACK];
    [self.labelMin setFont:POLICE_DATE_BIG];
    [self.labelMin setTextColor:COULEUR_BLACK];
    [self.labelSeparatorHourMin setFont:POLICE_DATE_PONCTUATION];
    [self.labelSeparatorHourMin setTextColor:COULEUR_HOME];
    
    //On met les images en couleurs
    [self.imageViewHeader setBackgroundColor:COULEUR_BLACK];
    [self.imageSeparatorDayMonth setBackgroundColor:COULEUR_HOME];
    [self.imageSeparatorDayHour setBackgroundColor:COULEUR_BACKGROUND];
    
    //On lance une première fois la mise à jour de la date pour pas avoir la latence d'une seconde
    [self updateDate];
    //On met à jour la date toute les secondes
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateDate) userInfo:nil repeats:YES];
    
    //On rajoute une notification pour mettre à jour la date quand on allume l'application
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDate) name:UPDATE_DATE object:nil];
}

//On met à jour la date
- (void)updateDate
{
    [self.labelDay setText:[DDHelperController getDayInLetter]];
    [self.labelNumberOfDay setText:[DDHelperController getDayInNumber]];
    [self.labelMonth setText:[DDHelperController getMonthInLetter]];
    [self.labelYear setText:[DDHelperController getYearInLetter]];
    [self.labelHour setText:[DDHelperController getHour]];
    [self.labelMin setText:[DDHelperController getMin]];
}

@end
