//
//  DDCustomButtonNotification.h
//  iTaskFamily
//
//  Created by Damien DELES on 12/03/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCustomButtonNotification : UIButton


#pragma mark - Variables

//Vue de séparation de la notification et du jour de la semaine
@property (strong, nonatomic) UIView *viewSeparator;

//Label pour afficher le nombre de notification
@property (strong, nonatomic) UILabel *labelNumberNotification;

//Label pour afficher le jour de la semaine
@property (strong, nonatomic) UILabel *labelDay;

//Couleur de la notification
@property (strong, nonatomic) UIColor *colorNotification;

//Booléen pour savoir si le boutton est sélectionné
@property (assign, nonatomic) BOOL isSelected;


#pragma mark - Fonctions

//On met à jour le composant
- (void)updateComponent;

@end
