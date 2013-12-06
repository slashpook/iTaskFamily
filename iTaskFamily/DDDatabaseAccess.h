//
//  DDDatabaseAccess.h
//  iTaskFamily
//
//  Created by Damien DELES on 29/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDDatabaseManager.h"

@class Player;
@class Categories;
@class Realisation;
@class Task;

@interface DDDatabaseAccess : NSObject


#pragma mark - Variables

//Instance de la base de donnée
@property (strong, nonatomic) DDDatabaseManager *dataBaseManager;


#pragma mark - Base Methods / save methods

//Initialisation du singleton
+ (DDDatabaseAccess *)instance;

//Sauvegare
- (BOOL)saveContext:(NSError *)error;

//Annulation de l'action
- (void)rollback;

//On récupère toutes les catégories
- (NSMutableArray *)getCategories;

//On récupère toutes les taches
- (NSMutableArray *)getTasks;

//On supprime la tache données
- (void)deleteTask:(Task *)task;

//On récupère les taches pour une category
- (NSMutableArray *)getTasksForCategory:(Categories *)category;

//On teste si la tache existe déjà ou non
- (BOOL)taskExistWithName:(NSString *)taskName;

//On récupère le nombre de trophées réalisé pour un joueur donnée à une catégorie donnée
- (int)getNumberOfTrophiesRealizedForPlayer:(Player *)player inCategory:(Categories *)category;

//On récupère le premier joueur
- (Player *)getFirstPlayer;

//On récupère tous les joueurs triés par le pseudo
- (NSMutableArray *)getPlayers;

//On récupère un joueur à l'index donnée
- (Player *)getPlayersAtIndex:(int)index;

//On supprime le joueur donnée
- (void)deletePlayer:(Player *)player;

//On vérifie si un joueur portant ce pseudo existe déjà ou non
- (BOOL)playerExistForPseudo:(NSString *)pseudo;

//On récupère la réalisation de bronze pour la tache donnée du player donné
- (Realisation *)getRealisationBronzeForTask:(Task *)task toPlayer:(Player *)player;

//On récupère la réalisation d'argent pour la tache donnée du player donné
- (Realisation *)getRealisationArgentForTask:(Task *)task toPlayer:(Player *)player;

//On récupère la réalisation d'or pour la tache donnée du player donné
- (Realisation *)getRealisationOrForTask:(Task *)task toPlayer:(Player *)player;

@end
