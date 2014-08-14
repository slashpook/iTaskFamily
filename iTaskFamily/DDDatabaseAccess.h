//
//  DDDatabaseAccess.h
//  DALiTaskFamily
//
//  Created by Damien DELES on 27/04/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDDatabaseManager.h"

@interface DDDatabaseAccess : NSObject

#pragma mark - Variables

//Instance de la base de donnée
@property (strong, nonatomic) DDDatabaseManager *dataBaseManager;


#pragma mark - Base Methods / save methods

//Initialisation du singleton
+ (DDDatabaseAccess *)instance;

//Sauvegare
- (BOOL)saveContext;

//Annulation de l'action
- (void)rollback;


#pragma mark - CRUD Achievement

//On crée l'achievement pour le player donné, la task donnée et la date donnée
- (Achievement *)createAchievementForPlayer:(Player *)player andTask:(Task *)task atWeekAndYear:(NSString *)weekAndYear;

//On récupère tous les achievements
- (NSArray *)getAchievements;

//On récupère tous les achievements d pour un player donné (utile pour récupérer les points totaux gagnés)
- (NSArray *)getAchievementsForPlayer:(Player *)player;

//On récupère tous les achievements pour un player donné à la catégorie donnée
- (NSArray *)getAchievementsForPlayer:(Player *)player forCategory:(CategoryTask *)category;

//On récupère tous les achievements d'une semaine donnée (utile pour récupérer les points gagnés dans la semaine)
- (NSArray *)getAchievementsForPlayer:(Player *)player atWeekAndYear:(NSString *)weekAndYear;

//On récupère l'achievement d'une semaine donnée pour un player donné et une task donnée
- (Achievement *)getAchievementsForPlayer:(Player *)player forTask:(Task *)task atWeekAndYear:(NSString *)weekAndYear;

//On supprime l'achievement donné
- (void)deleteAchievement:(Achievement *)achievement;


#pragma mark - CRUD CategoryTask

//On crée la categoryTask donnée
- (void)createCategoryTask:(CategoryTask *)categoryTask;

//On récupère toutes les categoryTasks
- (NSArray *)getCategoryTasks;

//On récupère la categoryTask pour le libelle donné
- (CategoryTask *)getCategoryTaskWithLibelle:(NSString *)libelle;

//On supprime la categoryTask donnée
- (void)deleteCategoryTask:(CategoryTask *)categoryTask;


#pragma mark - CRUD CategoryTrophy

//On crée le categoryTrophy après avoir fait quelques tests préalable
- (void)createCategoryTrophy:(CategoryTrophy *)categoryTrophy withCategory:(CategoryTask *)category;

//On récupère tous les categoryTrophies
- (NSArray *)getCategoryTrophies;

//On récupère tous les categoryTrophies de la categoryTask et on les trie
- (NSArray *)getCategoryTrophiesForCategorySorted:(CategoryTask *)categoryTask;

//On supprime le categoryTrophy donné
- (void)deleteCategoryTrophy:(CategoryTrophy *)categoryTrophy;


#pragma mark - CRUD Event

//On crée l'event après avoir fait quelques tests préalable
-(NSString *)createEvent:(Event *)event checked:(BOOL)checked forPlayer:(Player *)player forTask:(Task *)task atWeekAndYear:(NSString *)weekAndYear andForceUpdate:(BOOL)forceUpdate;

//On crée l'event avec une weekAndYear pour la récurrence
- (NSString *)createEvent:(Event *)event checked:(BOOL)checked forPlayer:(Player *)player forTask:(Task *)task atWeekAndYear:(NSString *)weekAndYear andRecurrenceEndAtWeekAndYear:(NSString *)weekAndYearRecurrence andForceUpdate:(BOOL)forceUpdate;

//On update l'event donné
- (void)updateEvent:(Event *)event;

//On update l'event donné après avoir fait quelques test
- (NSString *)updateEvent:(Event *)event forPlayer:(Player *)player forTask:(Task *)task atWeekAndYear:(NSString *)weekAndYear;

//On regarde si on a un évent qui existe déjà à la date donnée pour une tache donnée
- (BOOL)eventExistForPlayer:(Player *)player atWeekAndYear:(NSString *)weekAndYear forTask:(Task *)task andDay:(NSString *)day;

//On récupère tous les events
- (NSArray *)getEvents;

//On récupère tous les events d'un joueur données, pour une semaine donnée et un jour donné
- (NSArray *)getEventsForPlayer:(Player *)player atWeekAndYear:(NSString *)weekAndYear andDay:(NSString *)day;

//On récupère tous les events d'un joueur donné, pour une semaine donnée et une catégorie donnée
- (NSArray *)getEventsForPlayer:(Player *)player atWeekAndYear:(NSString *)weekAndYear forCategory:(CategoryTask *)category;

//On regarde si on a un évent qui existe dans le futur pour la tache donnée
- (Event *)getEventForPlayer:(Player *)player futureToWeekAndYear:(NSString *)weekAndYear forTask:(Task *)task andDay:(NSString *)day;

//On récupère tous les évènements lié à une tache, un jour donnée et une date de fin de récurrence
- (NSArray *)getEventsRecurrentForPlayer:(Player *)player atWeekAndYear:(NSString *)weekAndYear forTask:(Task *)task andDay:(NSString *)day;

//On récupère tous les event de la tache récurrent dans le futur pour la tache donnée
- (NSArray *)getEventsForPlayer:(Player *)player futureToWeekAndYear:(NSString *)weekAndYear forTask:(Task *)task andDay:(NSString *)day;

//On récupère tous l'évènement dans le passé le plus proche à celui que l'on crée est qui n'est pas terminé
- (Event *)getAnteriorEventRecurrentForPlayer:(Player *)player closeToWeekAndYear:(NSString *)weekAndYear forTask:(Task *)task andDay:(NSString *)day;

//On récupère l'event de l'achievement donnée, au jour donné
- (Event *)getEventForAchievement:(Achievement *)achievement andDay:(NSString *)day;

//On récupère le nombre d'event de l'achievement donnée, au jour donné
- (int)getCountOfEventForAchievement:(Achievement *)achievement andDay:(NSString *)day;

//On récupère tous les events réalisé d'un player donné pour une task donnée.
- (int)getNumberOfEventCheckedForPlayer:(Player *)player forTask:(Task *)task;

//On récupère tous les events non réalisé par le player pour le jour et la semaine donnée
- (int)getNumberOfEventCheckedForPlayer:(Player *)player forWeekAndYear:(NSString *)weekAndYear andDay:(NSString *)day;

- (int)getNumberOfEventUncheckedForPlayer:(Player *)player forWeekAndYear:(NSString *)weekAndYear andDay:(NSString *)day;

//On supprime l'event donné
- (void)deleteEvent:(Event *)event;


#pragma mark - CRUD Player

//On crée le player après avoir fait quelques tests préalable
- (NSString *)createPlayer:(Player *)player;

//On update le player donné après avoir fait quelques tests
- (NSString *)updatePlayer:(Player *)player;

//On récupère tous les players
- (NSArray *)getPlayers;

//On récupère le premier player
- (Player *)getFirstPlayer;

//On récupère le joueur donné
- (Player *)getPlayerForPseudo:(NSString *)pseudo;

//Retourne le nombre de player pour un pseudo donné
- (int)getCountOfPlayerForPseudo:(NSString *)pseudo;

//On récupère le joueur à l'index donné
- (Player *)getPlayerAtIndex:(int)index;

//On récupère le score de la semaine courante pour le player
- (int)getScoreWeekForPlayer:(Player *)player forWeekAndYear:(NSString *)weakAndYear;

//On récupère le score total pour le player
- (int)getScoreTotalForPlayer:(Player *)player;

//On récupère le score total pour le player pour la catégorie donnée
- (int)getScoreTotalForPlayer:(Player *)player forCategory:(CategoryTask *)category;

//On supprime le player donné
- (void)deletePlayer:(Player *)player;


#pragma mark - CRUD Reward

//On sauvegarde le reward après avoir fait quelques tests préalable
- (NSString *)saveReward:(Reward *)reward;

//On tri le tableau de rewards
- (NSArray *)getRewardSortedInArray:(NSArray *)arrayTrophies;

//On récupère le reward pour le type donnée
- (Reward *)getRewardForType:(NSString *)type;

//On supprime le reward donné
- (void)deleteReward:(Reward *)reward;


#pragma mark - CRUD Task

//On crée la task après avoir fait quelques tests préalable
- (NSString *)createTask:(Task *)task forCategory:(CategoryTask *)categoryTask withTrophies:(NSArray *)arrayTrophies;

//On update la task donnée après avoir fait quelques tests
- (NSString *)updateTask:(Task *)task;

//On récupère tous les tasks
- (NSArray *)getTasks;

//On récupère les tasks d'une categoryTask
- (NSArray *)getTasksForCategory:(CategoryTask *)category;

//On récupère le tableau des historique d'utilisation des tasks
- (NSArray *)getArrayHistoriqueTask;

//On récupère la task avec le libellé donné
- (Task *)getTaskWithLibelle:(NSString *)libelle;

//On renvoie le nombre de task avec le libellé donné
- (int)getCountOfTaskWithLibelle:(NSString *)libelle;

//On supprime la task donnée
- (void)deleteTask:(Task *)task;


#pragma mark - CRUD Trophy

//On crée le trophy après avoir fait quelques tests préalable
- (NSString *)createTrophy:(Trophy *)trophy;

//On update le trophy après avoir fait quelques tests préalable
- (NSString *)updateTrophy:(Trophy *)trophy;

//On récupère tous les trophies
- (NSArray *)getTrophies;

//On récupère le trophy pour le type donnée
- (Trophy *)getTrophyForType:(NSString *)type inArray:(NSArray *)arrayTrophies;

//On tri le tableau de trophies
- (NSArray *)getTrophiesSortedInArray:(NSArray *)arrayTrophies;

//On récupère le nombre de trophies réalisés pour un joueur donné
- (int)getNumberOfTrophyAchievedForPlayer:(Player *)player;

//On récupère le nombre de trophies réalisés pour un joueur donné, une catégorie donnée
- (int)getNumberOfTrophyAchievedForPlayer:(Player *)player inCategory:(CategoryTask *)category;

//On récupère le nombre de trophies réalisés pour un joueur donné, une catégorie donnée et un type de trophé donné;
- (int)getNumberOfTrophyAchievedForPlayer:(Player *)player inCategory:(CategoryTask *)category andType:(NSString *)type;

//On supprime le trophy donné
- (void)deleteTrophy:(Trophy *)trophy;

@end
