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
@class Event;

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


#pragma mark - CRUD Category

//On récupère toutes les catégories
- (NSMutableArray *)getCategories;

//On récupère la catégorie avec le nom donnée
- (Categories *)getCategoryWithName:(NSString *)categoryName;


#pragma mark - CRUD Task

//On récupère toutes les taches
- (NSMutableArray *)getTasks;

//On supprime la tache données
- (void)deleteTask:(Task *)task;

//On récupère les taches pour une category
- (NSMutableArray *)getTasksForCategory:(Categories *)category;

//On récupère la tache pour un joueur donnée
- (Task *)getTasksForPlayer:(Player *)player withTaskName:(NSString *)taskName;

//On récupère la tache pour lié à la catégorie
- (Task *)getTaskInCategory:(NSString *)categoryName WithTaskName:(NSString *)taskName;

//Récupère au maximum les 10 taches les plus utilisées
- (NSMutableArray *)getHistoriqueTask;

//On teste si la tache existe déjà ou non
- (BOOL)taskExistWithName:(NSString *)taskName;


#pragma mark - CRUD Trophy

//On récupère le nombre de trophées réalisé pour un joueur donnée à une catégorie donnée
- (int)getNumberOfTrophiesRealizedForPlayer:(Player *)player inCategory:(Categories *)category;

//On récupère la réalisation de bronze pour la tache donnée du player donné
- (Realisation *)getRealisationBronzeForTask:(Task *)task inPlayer:(Player *)player;

//On récupère la réalisation d'argent pour la tache donnée du player donné
- (Realisation *)getRealisationArgentForTask:(Task *)task inPlayer:(Player *)player;

//On récupère la réalisation d'or pour la tache donnée du player donné
- (Realisation *)getRealisationOrForTask:(Task *)task inPlayer:(Player *)player;

//On récupère la réalisation de bronze pour la tache donnée de la catégorie donnée
- (Realisation *)getRealisationBronzeForTask:(Task *)task inCategory:(Categories *)category;

//On récupère la réalisation d'argent pour la tache donnée de la catégorie donnée
- (Realisation *)getRealisationArgentForTask:(Task *)task inCategory:(Categories *)category;

//On récupère la réalisation d'or pour la tache donnée de la catégorie donnée
- (Realisation *)getRealisationOrForTask:(Task *)task inCategory:(Categories *)category;


#pragma mark - CRUD Player

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


#pragma mark - CRUD Event

//On récupère les évènements du joueur pour une date données
- (NSMutableArray *)getEventsForPlayer:(Player *)player atDay:(NSString *)day;

//On récupère le nombre d'évènement non terminés du joueur pour une date donnée
- (int)getCountOfEventsUnfinishedForPlayer:(Player *)player atDay:(NSString *)day;

//On récupère les event lié à la tache pour un joueur donnée
- (NSMutableArray *)getEventsForPlayer:(Player *)player withTaskName:(NSString *)taskName;

//On récupère l'event lié à la tache pour un joueur donnée à une date donnée
- (Event *)getEventsForPlayer:(Player *)player withTaskName:(NSString *)taskName atDay:(NSString *)day;

//On supprime un évènement
- (void)deleteEvent:(Event *)event;

@end
