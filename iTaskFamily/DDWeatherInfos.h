//
//  DDWeatherInfos.h
//  ITaskFamily
//
//  Created by DAMIEN DELES on 02/05/12.
//  Copyright (c) 2012 INGESUP. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DDWeatherInfosProtocol <NSObject>

//Recherche terminée avec succès
-(void)searchEnded:(id)weatherInfos;

//Recherche terminée avec erreur
-(void)searchEndedWithError:(id)weatherInfos;

@end

@interface DDWeatherInfos : NSObject <NSURLConnectionDelegate>


#pragma mark - Variables

//URL Connection pour lancer la récupération du JSON
@property(nonatomic, retain) NSURLConnection *connection;

//Web data pour récupérer le JSON de météo
@property(nonatomic, retain) NSMutableData *webData;

//Condition pour savoir quelle image afficher
@property(nonatomic, retain) NSString *condition;

//Nom de la ville
@property(nonatomic, retain) NSString *location;

//Température courante
@property(nonatomic, assign) NSInteger currentTemp;

//Température minimum
@property(nonatomic, assign) NSInteger lowTemp;

//Température maximum
@property(nonatomic, assign) NSInteger hightTemp;

//Delegate de l'objet
@property(nonatomic, retain) id<DDWeatherInfosProtocol> delegate;


#pragma mark - Fonctions

//Fonction d'initialisation
- (DDWeatherInfos *)initWithDelegate:(id<DDWeatherInfosProtocol>)delegate;

//On met à jour la météo avec la requette passé en paramètre
- (void)updateMeteoWithQuery:(NSString *)query;

@end
