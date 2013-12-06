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
@property(strong, nonatomic) NSURLConnection *connection;

//Web data pour récupérer le JSON de météo
@property(strong, nonatomic) NSMutableData *webData;

//Condition pour savoir quelle image afficher
@property(strong, nonatomic) NSString *condition;

//Nom de la ville
@property(strong, nonatomic) NSString *location;

//Température courante
@property(assign, nonatomic) NSInteger currentTemp;

//Température minimum
@property(assign, nonatomic) NSInteger lowTemp;

//Température maximum
@property(assign, nonatomic) NSInteger hightTemp;

//Delegate de l'objet
@property(weak, nonatomic) id<DDWeatherInfosProtocol> delegate;


#pragma mark - Fonctions

//Fonction d'initialisation
- (DDWeatherInfos *)initWithDelegate:(id<DDWeatherInfosProtocol>)delegate;

//On met à jour la météo avec la requette passé en paramètre
- (void)updateMeteoWithQuery:(NSString *)query;

@end
