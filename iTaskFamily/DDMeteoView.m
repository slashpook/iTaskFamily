//
//  DDMeteoView.m
//  iTaskFamily
//
//  Created by Damien DELES on 22/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDMeteoView.h"

@implementation DDMeteoView

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
    //On rempli le tableau
    _arrayIconMeteo = [[NSArray alloc] initWithObjects:@"113.png", @"122 - 119.png", @"260 - 248 - 143 - 116.png", @"296 - 293 - 266 - 263 - 176.png", @"350 - 284 - 281 - 182.png", @"359 - 356 - 353 - 308 - 305 - 302 - 299 - 185.png", @"365 - 362.png", @"368 - 335 - 332 - 329 - 326 - 323 - 179 - 392.png", @"377 - 374 - 320 - 317 - 314 - 311.png", @"389 - 200 - 386.png", @"395 - 371 - 338 - 230 - 227.png", nil];
    
    //On dessine la vue
    [self.layer setCornerRadius:10.0];
    [self.layer setMasksToBounds:YES];
    
    //On set la police et la couleur des labels
    [self.labelMeteo setFont:POLICE_HEADER];
    [self.labelMeteo setTextColor:COULEUR_WHITE];
    [self.labelTempCurrent setFont:POLICE_METEO_BIG];
    [self.labelTempCurrent setTextColor:COULEUR_BLACK];
    [self.labelTempCurrentTitle setFont:POLICE_METEO_MEDIUM];
    [self.labelTempCurrentTitle setTextColor:COULEUR_BLACK];
    [self.labelTempMax setFont:POLICE_METEO_BIG];
    [self.labelTempMax setTextColor:COULEUR_BLACK];
    [self.labelTempMaxTitle setFont:POLICE_METEO_MEDIUM];
    [self.labelTempMaxTitle setTextColor:COULEUR_BLACK];
    [self.labelTempMin setFont:POLICE_METEO_BIG];
    [self.labelTempMin setTextColor:COULEUR_BLACK];
    [self.labelTempMinTitle setFont:POLICE_METEO_MEDIUM];
    [self.labelTempMinTitle setTextColor:COULEUR_BLACK];
    
    //On met les images en couleurs
    [self.imageViewHeader setBackgroundColor:COULEUR_BLACK];
    [self.imageViewCurrent setBackgroundColor:COULEUR_BACKGROUND];
    [self.imageViewMax setBackgroundColor:COULEUR_BACKGROUND];
    [self.imageViewMin setBackgroundColor:COULEUR_BACKGROUND];
    
    //On initialise l'image de la météo (position et alpha)
    [self.constraintLeftImageMeteo setConstant:240];
    
    //On set l'activity indicator
    [self.activityIndicator setColor:COULEUR_BLACK];
    [self.activityIndicator setHidden:YES];
    
    //On crée le controller pour récupérer la météo
    _weatherInfos = [[DDWeatherInfos alloc] initWithDelegate:self];
    //On lance une première fois la mise à jour
    [self updateMeteo];
    //On met à jour la météo toute les 3 h
    [NSTimer scheduledTimerWithTimeInterval:3600.0 target:self selector:@selector(updateMeteo) userInfo:nil repeats:YES];
    
    //On rajoute une notification pour mettre à jour la météo quand on allume l'application
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMeteo) name:UPDATE_METEO object:nil];
}

//On met à jour la météo
- (void)updateMeteo
{
    //On met à jour l'activity indicator
    [self.activityIndicator startAnimating];
    [self.activityIndicator setHidden:NO];
    
    //Si on a pas la géolocalisation d'activé
    if ([CLLocationManager locationServicesEnabled] == NO || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [[DDManagerSingleton instance] isGeolocalisationActivate] == NO)
    {        
        //Si on a une ville par défault, on lance la géolocalisation
        [self.weatherInfos updateMeteoWithQuery:[[DDManagerSingleton instance] getMeteo]];
    }
    //Sinon on géolocalise
    else
    {
        [self.weatherInfos updateMeteoWithGeolocate];
    }
}

//On met à jour le graphisme
- (void)updateUI
{
    UIImage *imageMeteo;
    
    //On met à jour l'activity indicator
    [self.activityIndicator setHidden:YES];
    [self.activityIndicator stopAnimating];
    
    [self.labelMeteo setText:self.weatherInfos.location];
    [self.labelTempCurrent setText:[NSString stringWithFormat:@"%li", (long)self.weatherInfos.currentTemp]];
    [self.labelTempMax setText:[NSString stringWithFormat:@"%li", (long)self.weatherInfos.hightTemp]];
    [self.labelTempMin setText:[NSString stringWithFormat:@"%li", (long)self.weatherInfos.lowTemp]];
    
    //On regarde si on a la météo ou non pour setter l'image de la météo
    if ([self.weatherInfos.condition length] == 0)
    {
        imageMeteo = [UIImage imageNamed:@"NoMeteo"];
    }
    else
    {
        //On cherche l'image et on met à jour
        for (NSString *title in self.arrayIconMeteo)
        {
            if ([title rangeOfString:self.weatherInfos.condition].location != NSNotFound)
            {
                imageMeteo = [UIImage imageNamed:title];
                break;
            }
        }
    }
    
    //On lance l'animation pour mettre à jour l'image de la météo
    [self setNeedsUpdateConstraints];
    if (self.constraintLeftImageMeteo.constant == 68)
    {
        [self.constraintLeftImageMeteo setConstant:240];
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.imageViewMeteo setImage:imageMeteo];
            [self setNeedsUpdateConstraints];
            [self.constraintLeftImageMeteo setConstant:68];
            [UIView animateWithDuration:0.3 animations:^{
                [self layoutIfNeeded];
            }];
        }];
    }
    else
    {
        [self.imageViewMeteo setImage:imageMeteo];
        [self.constraintLeftImageMeteo setConstant:68];
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        }];
    }
}


#pragma mark Fonctions de WeatherInfosProtocol

//Recherche terminé avec succès
- (void)searchEnded:(id)weatherInfos
{
    [self updateUI];
}

//Recherche terminé avec erreur
- (void)searchEndedWithError:(id)weatherInfos
{
    [self updateUI];
}

@end
