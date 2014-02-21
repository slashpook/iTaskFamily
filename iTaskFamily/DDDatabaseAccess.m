//
//  DDDatabaseAccess.m
//  iTaskFamily
//
//  Created by Damien DELES on 29/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDDatabaseAccess.h"
#import "Player.h"
#import "Categories.h"
#import "Trophy.h"
#import "Realisation.h"
#import "Task.h"
#import "Event.h"

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


#pragma mark - CRUD Category

//On récupère toutes les catégories
- (NSMutableArray *)getCategories
{
    NSMutableArray *arrayCategories = nil;
    
    //On Défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Categories" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //Si on a des joueurs, on les rentres dans le tableau
    if (fetchedObjects.count > 0)
    {
        fetchedObjects = [fetchedObjects sortedArrayUsingComparator:^NSComparisonResult(Categories *obj1, Categories *obj2) {
            return (NSComparisonResult)[obj1.name compare:obj2.name];
        }];
        
        //On récupère le premier joueur
        arrayCategories = [NSMutableArray arrayWithArray:fetchedObjects];
    }
    
    return arrayCategories;
}

//On récupère la catégorie avec le nom donnée
- (Categories *)getCategoryWithName:(NSString *)categoryName
{
    //On récupère le tableau des catégories
    NSMutableArray *arrayCategory = [self getCategories];
    
    //On parse le tableau pour renvoyer la catégorie recherchée
    for (Categories *category in arrayCategory)
    {
        if ([category.name isEqualToString:categoryName])
        {
            return category;
        }
    }

    return nil;
}


#pragma mark - CRUD Task

//On récupère toutes les taches
- (NSMutableArray *)getTasks
{
    NSArray *arrayTask = nil;
    
    //On Défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Categories" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //Si on a des joueurs, on les rentres dans le tableau
    if (fetchedObjects.count > 0)
    {
        fetchedObjects = [fetchedObjects sortedArrayUsingComparator:^NSComparisonResult(Categories *obj1, Categories *obj2) {
            return (NSComparisonResult)[obj1.name compare:obj2.name];
        }];
        
        for (Categories *categorie in fetchedObjects)
        {
            arrayTask = [NSArray arrayWithArray:[arrayTask arrayByAddingObjectsFromArray:[[categorie task] allObjects]]];
        }
    }
    
    return [NSMutableArray arrayWithArray:arrayTask];
}

//On teste si la tache existe déjà ou non
- (BOOL)taskExistWithName:(NSString *)taskName
{
    NSMutableArray *arrayTask = [self getTasks];
    
    //On boucle sur le tableau de tache pour voir si elle existe déjà
    for (Task *task in arrayTask)
    {
        if ([task.name isEqualToString:taskName])
        {
            return YES;
        }
    }
    
    return NO;
}

//On récupère les taches pour une category
- (NSMutableArray *)getTasksForCategory:(Categories *)category
{
    NSArray *arrayTask = [NSArray arrayWithArray:[category.task allObjects]];
    
    arrayTask = [arrayTask sortedArrayUsingComparator:^NSComparisonResult(Task *obj1, Task *obj2) {
        return (NSComparisonResult)[obj1.name compare:obj2.name];
    }];
    
    return [NSMutableArray arrayWithArray:arrayTask];
}

//On récupère la tache pour un joueur donnée
- (Task *)getTasksForPlayer:(Player *)player withTaskName:(NSString *)taskName
{
    //On boucle sur les taches du joueur pour trouver la tache
    for (Task *task in [player.task allObjects])
    {
        if ([task.name isEqualToString:taskName])
            return task;
    }

    return nil;
}

//On récupère la tache pour lié à la catégorie
- (Task *)getTaskInCategory:(NSString *)categoryName WithTaskName:(NSString *)taskName
{
    //On récupère la categorie donnée
    Categories *category = [self getCategoryWithName:categoryName];
    
    //On boucle sur les taches de la categorie pour trouver la tache
    for (Task *task in [category.task allObjects])
    {
        if ([task.name isEqualToString:taskName])
            return task;
    }
    
    return nil;
}

//Récupère au maximum les 10 taches les plus utilisées
- (NSMutableArray *)getHistoriqueTask
{
    //On récupère les taches
    NSMutableArray *arrayTask = [self getTasks];
    
    NSMutableArray *arrayHistoriqueTask = [NSMutableArray array];
    
    //Si on a des taches
    if ([arrayTask count] > 0)
    {
        NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"historique" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sorter];
        [arrayTask sortUsingDescriptors:sortDescriptors];
        
        int compteur;
        
        //On configure le compteur en fonction du nombre de taches présentes
        if ([arrayTask count] < 10)
            compteur = [arrayTask count];
        else
            compteur = 10;
        
        for (int i = 0; i < compteur; i++)
            [arrayHistoriqueTask addObject:[arrayTask objectAtIndex:i]];
    }
    
    return arrayHistoriqueTask;
}

//On supprime la tache données
- (void)deleteTask:(Task *)task
{
    //On supprime la tache pour les joueurs ainsi que les éventuels évènements
    for (Player *player in [self getPlayers])
    {
        //Suppression de la tache du joueur
        Task *taskPlayer = [self getTasksForPlayer:player withTaskName:task.name];
        [self.dataBaseManager.managedObjectContext deleteObject:taskPlayer];
        
        //Suppression des events du joueur liés à la tache
        NSMutableArray *arrayEventPlayer = [self getEventsForPlayer:player withTaskName:task.name];
        for (Event *eventPlayer in arrayEventPlayer)
        {
            [self.dataBaseManager.managedObjectContext deleteObject:eventPlayer];
#warning Enlever les éventuels points gagnés par le joueur
        }
    }
    
    //Suppression de la tache lié à la catégorie
    Task *taskCategory = [self getTaskInCategory:task.categories.name WithTaskName:task.name];
    [self.dataBaseManager.managedObjectContext deleteObject:taskCategory];
    
    [self saveContext:nil];
}


#pragma mark - Trophy

//On récupère le nombre de trophées réalisé pour un joueur donnée à une catégorie donnée
- (int)getNumberOfTrophiesRealizedForPlayer:(Player *)player inCategory:(Categories *)category
{
    int counter = 0;
    
    //On boucle sur les taches du joueur
    for (Task *task in [player.task allObjects])
    {
        //Si la tache est dans la catégorie donnée
        if ([task.categories.name isEqualToString:category.name])
        {
            //On boucle sur toute les réalisations et on regarde si on les a faites ou pas
            for (Realisation *realisation in [task realisation])
            {
                if ([[realisation realized] intValue] >= [[realisation total] intValue])
                {
                    counter += 1;
                }
            }
        }
    }
    
    return counter;
}

//On récupère la réalisation de bronze pour la tache donnée du player donné
- (Realisation *)getRealisationBronzeForTask:(Task *)task inPlayer:(Player *)player
{
    Realisation *realisation = nil;
    
    //On boucle sur les taches du joueur
    for (Task *taskPlayer in [player.task allObjects])
    {
        //Si la tache est dans la catégorie donnée
        if ([taskPlayer.name isEqualToString:task.name])
        {
            //On boucle sur toute les réalisations et on regarde si on les a faites ou pas
            for (Realisation *realisationTask in [taskPlayer realisation])
            {
                if ([[realisationTask type] isEqualToString:@"Bronze"])
                {
                    realisation = realisationTask;
                }
            }
        }
    }
    
    return realisation;
}

//On récupère la réalisation d'argent pour la tache donnée du player donné
- (Realisation *)getRealisationArgentForTask:(Task *)task inPlayer:(Player *)player
{
    Realisation *realisation = nil;
    
    //On boucle sur les taches du joueur
    for (Task *taskPlayer in [player.task allObjects])
    {
        //Si la tache est dans la catégorie donnée
        if ([taskPlayer.name isEqualToString:task.name])
        {
            //On boucle sur toute les réalisations et on regarde si on les a faites ou pas
            for (Realisation *realisationTask in [taskPlayer realisation])
            {
                if ([[realisationTask type] isEqualToString:@"Argent"])
                {
                    realisation = realisationTask;
                }
            }
        }
    }
    
    return realisation;
}

//On récupère la réalisation d'or pour la tache donnée du player donné
- (Realisation *)getRealisationOrForTask:(Task *)task inPlayer:(Player *)player
{
    Realisation *realisation = nil;
    
    //On boucle sur les taches du joueur
    for (Task *taskPlayer in [player.task allObjects])
    {
        //Si la tache est dans la catégorie donnée
        if ([taskPlayer.name isEqualToString:task.name])
        {
            //On boucle sur toute les réalisations et on regarde si on les a faites ou pas
            for (Realisation *realisationTask in [taskPlayer realisation])
            {
                if ([[realisationTask type] isEqualToString:@"Or"])
                {
                    realisation = realisationTask;
                }
            }
        }
    }
    
    return realisation;
}

//On récupère la réalisation de bronze pour la tache donnée de la catégorie donnée
- (Realisation *)getRealisationBronzeForTask:(Task *)task inCategory:(Categories *)category
{
    Realisation *realisation = nil;
    
    //On boucle sur les taches du joueur
    for (Task *taskCategory in [category.task allObjects])
    {
        //Si la tache est dans la catégorie donnée
        if ([taskCategory.name isEqualToString:task.name])
        {
            //On boucle sur toute les réalisations et on regarde si on les a faites ou pas
            for (Realisation *realisationTask in [taskCategory realisation])
            {
                if ([[realisationTask type] isEqualToString:@"Bronze"])
                {
                    realisation = realisationTask;
                }
            }
        }
    }
    
    return realisation;
}

//On récupère la réalisation d'argent pour la tache donnée de la catégorie donnée
- (Realisation *)getRealisationArgentForTask:(Task *)task inCategory:(Categories *)category
{
    Realisation *realisation = nil;
    
    //On boucle sur les taches du joueur
    for (Task *taskCategory in [category.task allObjects])
    {
        //Si la tache est dans la catégorie donnée
        if ([taskCategory.name isEqualToString:task.name])
        {
            //On boucle sur toute les réalisations et on regarde si on les a faites ou pas
            for (Realisation *realisationTask in [taskCategory realisation])
            {
                if ([[realisationTask type] isEqualToString:@"Argent"])
                {
                    realisation = realisationTask;
                }
            }
        }
    }
    
    return realisation;
}

//On récupère la réalisation d'or pour la tache donnée de la catégorie donnée
- (Realisation *)getRealisationOrForTask:(Task *)task inCategory:(Categories *)category
{
    Realisation *realisation = nil;
    
    //On boucle sur les taches du joueur
    for (Task *taskCategory in [category.task allObjects])
    {
        //Si la tache est dans la catégorie donnée
        if ([taskCategory.name isEqualToString:task.name])
        {
            //On boucle sur toute les réalisations et on regarde si on les a faites ou pas
            for (Realisation *realisationTask in [taskCategory realisation])
            {
                if ([[realisationTask type] isEqualToString:@"Or"])
                {
                    realisation = realisationTask;
                }
            }
        }
    }
    
    return realisation;
}


#pragma mark - Player

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


#pragma mark - Event

//On récupère les event lié à la tache pour un joueur donnée
- (NSMutableArray *)getEventsForPlayer:(Player *)player withTaskName:(NSString *)taskName
{
    NSMutableArray *arrayEvents = nil;
    
    //On boucle sur les events du joueur pour trouver les éventuels events
    for (Event *event in [player.events allObjects])
    {
        if ([event.task.name isEqualToString:taskName])
            [arrayEvents addObject:event];
    }
    
    return arrayEvents;
}

@end
