//
//  DDDatabaseAccess.m
//  iTaskFamily
//
//  Created by Damien DELES on 29/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDDatabaseAccess.h"
#import "Player.h"

@implementation DDDatabaseAccess


#pragma mark - Init

//Instance du singleton
+ (DDDatabaseAccess *)instance
{
	static DDDatabaseAccess *instance;
	
	@synchronized(self) {
		if(!instance) {
			instance = [[DDDatabaseAccess alloc] init];
		}
	}
	
	return instance;
}

-(id) init
{
    self = [super init];
    if (self != nil)
    {
        self.dataBaseManager = [[DDDatabaseManager alloc] init];
    }
    return self;
}


#pragma mark - Base Methods

//On sauvegarde les données
- (BOOL)saveContext:(NSError *)error
{
    return [self.dataBaseManager saveContext:error];
}

//On annule les modifications
- (void)rollback
{
    [self.dataBaseManager.managedObjectContext rollback];
}

//On récupère le premier joueur
- (Player *)getFirstPlayer
{
    Player *player = nil;
    
    //On Défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Player" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //Si on a des objets on retourne NO
    if (fetchedObjects.count > 0)
    {
        fetchedObjects = [fetchedObjects sortedArrayUsingComparator:^NSComparisonResult(Player *obj1, Player *obj2) {
            return (NSComparisonResult)[obj1.pseudo compare:obj2.pseudo];
        }];
        
        //On récupère le premier joueur
        player = [fetchedObjects firstObject];
    }
    
    return player;
}

//On récupère tous les joueurs triés par le pseudo
- (NSMutableArray *)getPlayers
{
    NSMutableArray *arrayPlayer = nil;
    
    //On Défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Player" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //Si on a des joueurs, on les rentres dans le tableau
    if (fetchedObjects.count > 0)
    {
        fetchedObjects = [fetchedObjects sortedArrayUsingComparator:^NSComparisonResult(Player *obj1, Player *obj2) {
            return (NSComparisonResult)[obj1.pseudo compare:obj2.pseudo];
        }];
        
        //On récupère le premier joueur
        arrayPlayer = [NSMutableArray arrayWithArray:fetchedObjects];
    }
    
    return arrayPlayer;
}

//On récupère le joueur à l'index donnée
- (Player *)getPlayersAtIndex:(int)index
{
    Player *player = nil;
    
    //On Défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Player" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //Si on a des joueurs, on les rentres dans le tableau
    if (fetchedObjects.count > 0)
    {
        fetchedObjects = [fetchedObjects sortedArrayUsingComparator:^NSComparisonResult(Player *obj1, Player *obj2) {
            return (NSComparisonResult)[obj1.pseudo compare:obj2.pseudo];
        }];
        
        //On récupère le premier joueur
        player = [fetchedObjects objectAtIndex:index];
    }
    
    return player;
}

//On supprime le joueur donnée
- (void)deletePlayer:(Player *)player
{
    //On supprime l'image puis le joueur
    [[NSFileManager defaultManager] removeItemAtPath:player.pathImage error:nil];
    [self.dataBaseManager.managedObjectContext deleteObject:player];
    [self saveContext:nil];
}

//On vérifie si un joueur portant ce pseudo existe déjà ou non
- (BOOL)playerExistForPseudo:(NSString *)pseudo
{
    //On Défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Player" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    //On rajoute un filtre
    NSPredicate *newPredicate =
    [NSPredicate predicateWithFormat:@"pseudo == %@", pseudo];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //Si on a des objets on retourne YES
    if (fetchedObjects.count > 0)
        return YES;
    else
        return NO;
}

@end
