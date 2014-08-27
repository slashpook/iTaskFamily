//
//  DDManagerSingleton.h
//  iTaskFamily
//
//  Created by Damien DELES on 29/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDManagerSingleton : NSObject


#pragma mark - Variables

//Storyboard de l'application
@property (strong, nonatomic) UIStoryboard *storyboard;

//Array des images de la bibliothèque
@property (strong, nonatomic) NSMutableArray *arrayImagePicker;

//Array des jours de la semaine
@property (strong, nonatomic) NSArray *arrayWeek;

//Array des mois de l'année
@property (strong, nonatomic) NSArray *arrayMonth;

//Référence vers la bibliothèque
@property (strong, nonatomic) ALAssetsLibrary *library;

//Une référence sur le joueur en cours
@property (strong, nonatomic) Player *currentPlayer;

//Dictionnaire des images du joueur
@property (strong, nonatomic) NSMutableDictionary *dictImagePlayer;

//Dictinonaire des couleurs des catégories
@property (strong, nonatomic) NSDictionary *dictColor;

//Variable contenant le jour actuel
@property (strong, nonatomic) NSString *currentDate;

//Variable contenant la date sélectionnée pour visionner l'event
@property (strong, nonatomic) NSDate *currentDateSelected;


#pragma mark - Fonctions

//Instance du singleton
+ (DDManagerSingleton *)instance;

//On charge les images de la bibliothèque
- (void)loadImagePicker;

//On enregistre l'image de profil du joueur et on set son chemin
- (void)saveImgProfilForPlayer:(Player *)player withImage:(UIImage *)imgProfil;

//On met à jour l'image de profil du joueur
- (void)updateImgProfilForPlayer:(Player *)player WithPath:(NSString *)path withImage:(UIImage *)imgProfil;

//Indique si on se géolocalise ou non
- (BOOL)isGeolocalisationActivate;

//Set la géolocalisation
- (void)setIsGeolocationActivate:(BOOL)isGeolocalisationActivate;

//On récupère la météo
- (NSString *)getMeteo;

//Set la météo
- (void)setMeteo:(NSString *)meteo;

@end
