//
//  DDCustomProgressBar.h
//  iTaskFamily
//
//  Created by Damien DELES on 05/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Categories;
@class Realisation;

@interface DDCustomProgressBar : UIView


#pragma mark - Variables

//Realisation en cours
@property (strong, nonatomic) Realisation *realisation;

//Couleur de fond
@property (strong, nonatomic) UIColor *colorBackground;

//Couleur de remplissage
@property (strong, nonatomic) UIColor *colorRealisation;

//Taille de la progressBar
@property (assign, nonatomic) int width;


#pragma mark - Fonctions


@end
