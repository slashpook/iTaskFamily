//
//  DDCustomProgressBar.h
//  iTaskFamily
//
//  Created by Damien DELES on 05/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCustomProgressBar : UIView


#pragma mark - Variables

//Trophy en cours
@property (strong, nonatomic) Trophy *trophy;

//Player courant
@property (strong, nonatomic) Player *player;

//Couleur de fond
@property (strong, nonatomic) UIColor *colorBackground;

//Couleur de remplissage
@property (strong, nonatomic) UIColor *colorRealisation;

//Taille de la progressBar
@property (assign, nonatomic) int width;


#pragma mark - Fonctions


@end
