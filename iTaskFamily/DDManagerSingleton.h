//
//  DDManagerSingleton.h
//  iTaskFamily
//
//  Created by Damien DELES on 29/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Player;

@interface DDManagerSingleton : NSObject


#pragma mark - Variables

//Array des images de la bibliothèque
@property (strong, nonatomic) NSMutableArray *arrayImagePicker;

//Référence vers la bibliothèque
@property (strong, nonatomic) ALAssetsLibrary *library;

//Une référence sur le joueur en cours
@property (strong, nonatomic) Player *currentPlayer;

//Dictionnaire des images du joueur
@property (strong, nonatomic) NSMutableDictionary *dictImagePlayer;


#pragma mark - Fonctions

//Instance du singleton
+ (DDManagerSingleton *)instance;

//On charge les images de la bibliothèque
- (void)loadImagePicker;

//On enregistre l'image de profil du joueur et on set son chemin
- (void)saveImgProfilForPlayer:(Player *)player withImage:(UIImage *)imgProfil;

//On met à jour l'image de profil du joueur
- (void)updateImgProfilForPlayer:(Player *)player WithPath:(NSString *)path withImage:(UIImage *)imgProfil;

@end
