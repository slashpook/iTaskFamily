//
//  DDMeteoView.h
//  iTaskFamily
//
//  Created by Damien DELES on 22/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDWeatherInfos.h"

@interface DDMeteoView : UIView <DDWeatherInfosProtocol>


#pragma mark - Variables

//Controller pour gérer la météo
@property (strong, nonatomic)DDWeatherInfos *weatherInfos;

//Array des images de la météo
@property (strong, nonatomic)NSArray *arrayIconMeteo;

//Image du haut de la vue
@property (weak, nonatomic)IBOutlet UIImageView *imageViewHeader;

//Label du jour de la semaine
@property (weak, nonatomic)IBOutlet UILabel *labelMeteo;

//Activity indicator de l'update de la météo
@property (weak, nonatomic)IBOutlet UIActivityIndicatorView *activityIndicator;

//Label de la température courante
@property (weak, nonatomic)IBOutlet UILabel *labelTempCurrent;

//Label du titre de la température courante
@property (weak, nonatomic)IBOutlet UILabel *labelTempCurrentTitle;

//Image de separation de la temperature courante
@property (weak, nonatomic)IBOutlet UIImageView *imageViewCurrent;

//Label de la température Max
@property (weak, nonatomic)IBOutlet UILabel *labelTempMax;

//Label du titre de la température Max
@property (weak, nonatomic)IBOutlet UILabel *labelTempMaxTitle;

//Image de separation de la temperature Max
@property (weak, nonatomic)IBOutlet UIImageView *imageViewMax;

//Label de la température Min
@property (weak, nonatomic)IBOutlet UILabel *labelTempMin;

//Label du titre de la température Min
@property (weak, nonatomic)IBOutlet UILabel *labelTempMinTitle;

//Image de separation de la temperature Min
@property (weak, nonatomic)IBOutlet UIImageView *imageViewMin;

//Image de la représentation de la météo
@property (weak, nonatomic)IBOutlet UIImageView *imageViewMeteo;

//Contrainte de l'image de la météo de gauche
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeftImageMeteo;


#pragma mark - Fonctions

@end
