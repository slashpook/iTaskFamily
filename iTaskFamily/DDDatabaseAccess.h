//
//  DDDatabaseAccess.h
//  iTaskFamily
//
//  Created by Damien DELES on 29/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
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
- (BOOL)saveContext:(NSError *)error;

//Annulation de l'action
- (void)rollback;

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

@end
