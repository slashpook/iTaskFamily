//
//  DDDatabaseAccess.m
//  DALiTaskFamily
//
//  Created by Damien DELES on 27/04/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDDatabaseAccess.h"
#import "DDParserXML.h"

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
- (BOOL)saveContext
{
    NSError *error = nil;
    return [self.dataBaseManager saveContext:error];
}

//On annule les modifications
- (void)rollback
{
    [self.dataBaseManager.managedObjectContext rollback];
}

//On récupère tous les objets de l'entity donnée et on la trie s'il le faut
- (NSArray *)getAllObjectForEntity:(NSString *)entityName andSortWithProperties:(NSString *)sortProperties
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:entityName inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On trie la requète s'il le faut
    if (sortProperties != nil) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortProperties
                                                                       ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    
    NSError *error;
    
    //On renvoie le tableau de la requète
    return [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}


#pragma mark - CRUD Achievement


//On crée l'achievement pour le player donné, la task donnée et la date donnée
- (Achievement *)createAchievementForPlayer:(Player *)player andTask:(Task *)task atWeekAndYear:(NSString *)weekAndYear
{
    Achievement *achievement = [NSEntityDescription insertNewObjectForEntityForName:@"Achievement"
                                                             inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [achievement setWeekAndYear:weekAndYear];
    [achievement setPlayer:player];
    [achievement setTask:task];
    
    return achievement;
}

//On récupère tous les achievements
- (NSArray *)getAchievements
{
    NSArray *arrayEntities = [self getAllObjectForEntity:@"Achievement" andSortWithProperties:@"weekAndYear"];
    
    return arrayEntities;
}

//On récupère tous les achievements pour un player donné (utile pour récupérer les points totaux gagnés)
- (NSArray *)getAchievementsForPlayer:(Player *)player
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Achievement" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"player.pseudo == %@", player.pseudo];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    
    //On renvoie le tableau de la requète
    return [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

//On récupère tous les achievements pour une tache donnée
- (NSArray *)getAchievementsForTask:(Task *)task
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Achievement" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"task.libelle == %@", task.libelle];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    
    //On renvoie le tableau de la requète
    return [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

//On récupère tous les achievements pour un player donné à la catégorie donnée
- (NSArray *)getAchievementsForPlayer:(Player *)player forCategory:(CategoryTask *)category
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Achievement" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"player.pseudo == %@ && task.category.libelle == %@", player.pseudo, category.libelle];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    
    //On renvoie le tableau de la requète
    return [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

//On récupère tous les achievements d'une semaine donnée pour un player donné (utile pour récupérer les points gagnés dans la semaine)
- (NSArray *)getAchievementsForPlayer:(Player *)player atWeekAndYear:(NSString *)weekAndYear
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Achievement" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"player.pseudo == %@ && weekAndYear == %@", player.pseudo, weekAndYear];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    
    //On renvoie le tableau de la requète
    return [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

//On récupère l'achievement d'une semaine donnée pour un player donné et une task donnée
- (Achievement *)getAchievementsForPlayer:(Player *)player forTask:(Task *)task atWeekAndYear:(NSString *)weekAndYear
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Achievement" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"player.pseudo == %@ && task.libelle = %@ && weekAndYear == %@", player.pseudo, task.libelle, weekAndYear];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //On renvoie l'achievement s'il existe
    if ([fetchedObjects count] > 0)
        return [fetchedObjects objectAtIndex:0];
    else
        return nil;
}

//On supprime l'achievement donné
- (void)deleteAchievement:(Achievement *)achievement
{
    [self.dataBaseManager.managedObjectContext deleteObject:achievement];
    [self saveContext];
}


#pragma mark - CRUD CategoryTask

//On crée la categoryTask donnée
- (void)createCategoryTask:(CategoryTask *)categoryTask
{
    [self.dataBaseManager.managedObjectContext insertObject:categoryTask];
    [self saveContext];
}

//On récupère toutes les categoryTasks
- (NSArray *)getCategoryTasks
{
    NSArray *arrayEntities = [self getAllObjectForEntity:@"CategoryTask" andSortWithProperties:@"libelle"];
    
    return arrayEntities;
}

//On récupère la categoryTask pour le libelle donné
- (CategoryTask *)getCategoryTaskWithLibelle:(NSString *)libelle
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"CategoryTask" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"libelle == %@", libelle];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchedObjects count] > 0)
        return [fetchedObjects objectAtIndex:0];
    else
        return nil;
    
}

//On supprime la categoryTask donnée
- (void)deleteCategoryTask:(CategoryTask *)categoryTask
{
    [self.dataBaseManager.managedObjectContext deleteObject:categoryTask];
    [self saveContext];
}


#pragma mark - CRUD CategoryTrophy

//On crée le player après avoir fait quelques tests préalable
- (void)createCategoryTrophy:(CategoryTrophy *)categoryTrophy withCategory:(CategoryTask *)category
{
    [self.dataBaseManager.managedObjectContext insertObject:categoryTrophy];
    [categoryTrophy setCategory:category];
    [self saveContext];
}

//On récupère tous les categoryTrophies
- (NSArray *)getCategoryTrophies
{
    NSArray *arrayEntities = [self getAllObjectForEntity:@"CategoryTrophy" andSortWithProperties:@"category.libelle"];
    
    return arrayEntities;
}

//On récupère tous les categoryTrophies de la categoryTask et on les trie
- (NSArray *)getCategoryTrophiesForCategorySorted:(CategoryTask *)categoryTask
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"CategoryTrophy" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"category.libelle == %@", categoryTask.libelle];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchedObjects count] == 3)
        return [self getTrophiesSortedInArray:fetchedObjects];
    else
        return nil;
}

//On supprime le categoryTrophy donné
- (void)deleteCategoryTrophy:(CategoryTrophy *)categoryTrophy
{
    [self.dataBaseManager.managedObjectContext deleteObject:categoryTrophy];
    [self saveContext];
}


#pragma mark - CRUD Event


//On crée l'event après avoir fait quelques tests préalable
- (NSString *)createEvent:(Event *)event checked:(BOOL)checked forPlayer:(Player *)player forTask:(Task *)task atWeekAndYear:(NSString *)weekAndYear andForceUpdate:(BOOL)forceUpdate
{
    //Si on a une tache
    if (task != nil)
    {
        //On récupère l'achievement du player s'il existe
        Achievement *achievement = [self getAchievementsForPlayer:player forTask:task atWeekAndYear:weekAndYear];
        
        //S'il n'existe pas, on le crée
        if (achievement == nil)
            achievement = [self createAchievementForPlayer:player andTask:task atWeekAndYear:weekAndYear];
        
        //On regarde si on a pas déjà un event qui existe pour ce jour
        Event *eventInDB = [self getEventForAchievement:achievement andDay:event.day forTask:task];
        
        //Si on force pas l'update, on retourne un message d'erreur si l'event existe déjà
        if (eventInDB != nil && forceUpdate == NO)
            return @"Un évènement existe déjà pour cette tache";
        //On supprime l'event sinon avant de créer le nouveau
        else if (eventInDB != nil && forceUpdate == YES)
            [self deleteEvent:eventInDB];
        
        //On sauvegarde l'event
        [self.dataBaseManager.managedObjectContext insertObject:event];
        [achievement addEventsObject:event];
        
        //On crée la date de fin de récurrence
        RecurrenceEnd *recurrenceEnd = [NSEntityDescription insertNewObjectForEntityForName:@"RecurrenceEnd"
                                                                     inManagedObjectContext:self.dataBaseManager.managedObjectContext];
        
        //On set le booléen de réalisation
        [event setChecked:[NSNumber numberWithBool:checked]];
        
        //On set si on doit gérer une date de fin ou pas
        if ([event.recurrent boolValue] == YES)
            [recurrenceEnd setWeekAndYear:@"0"];
        else
            [recurrenceEnd setWeekAndYear:@"-1"];
        [event setRecurrenceEnd:recurrenceEnd];
        
        [self saveContext];
        return nil;
    }
    else
        return @"Veuillez renseigner une tache !";
}

//On crée l'event avec une weekAndYear pour la récurrence
- (NSString *)createEvent:(Event *)event checked:(BOOL)checked forPlayer:(Player *)player forTask:(Task *)task atWeekAndYear:(NSString *)weekAndYear andRecurrenceEndAtWeekAndYear:(NSString *)weekAndYearRecurrence andForceUpdate:(BOOL)forceUpdate
{
    //Si on a une tache
    if (task != nil)
    {
        //On récupère l'achievement du player s'il existe
        Achievement *achievement = [self getAchievementsForPlayer:player forTask:task atWeekAndYear:weekAndYear];
        
        //S'il n'existe pas, on le crée
        if (achievement == nil)
            achievement = [self createAchievementForPlayer:player andTask:task atWeekAndYear:weekAndYear];
        else
        {
            //On regarde si on a pas déjà un event qui existe pour ce jour
            Event *eventInDB = [self getEventForAchievement:achievement andDay:event.day forTask:task];
            
            //Si on force pas l'update, on retourne un message d'erreur si l'event existe déjà
            if (eventInDB != nil && forceUpdate == NO)
                return @"Un évènement existe déjà pour cette tache";
            //On supprime l'event sinon avant de créer le nouveau
            else if (eventInDB != nil && forceUpdate == YES)
                [self deleteEvent:eventInDB];
        }
        
        //On sauvegarde l'event
        [self.dataBaseManager.managedObjectContext insertObject:event];
        [achievement addEventsObject:event];
        
        //On set le booléen de réalisation
        [event setChecked:[NSNumber numberWithBool:checked]];
        
        //On crée la date de fin de récurrence
        RecurrenceEnd *recurrenceEnd = [NSEntityDescription insertNewObjectForEntityForName:@"RecurrenceEnd"
                                                                     inManagedObjectContext:self.dataBaseManager.managedObjectContext];
        [recurrenceEnd setWeekAndYear:weekAndYearRecurrence];
        [event setRecurrenceEnd:recurrenceEnd];
        
        [self saveContext];
        return nil;
    }
    else
        return @"Veuillez renseigner une tache !";
}

//On update l'event donné
- (void)updateEvent:(Event *)event
{
    //On sauvegarde l'event
    [self saveContext];
}

//On update l'event donné après avoir fait quelques test
- (NSString *)updateEvent:(Event *)event forPlayer:(Player *)player forTask:(Task *)task atWeekAndYear:(NSString *)weekAndYear
{
    //On récupère l'achievement du player s'il existe
    Achievement *achievement = [self getAchievementsForPlayer:player forTask:task atWeekAndYear:weekAndYear];
    
    //S'il n'existe pas, on le crée
    if (achievement == nil)
        achievement = [self createAchievementForPlayer:player andTask:task atWeekAndYear:weekAndYear];
    
    [event setAchievement:achievement];
    
    //On set si on doit gérer une date de fin ou pas
    if ([event.recurrent boolValue] == YES)
        [event.recurrenceEnd setWeekAndYear:@"0"];
    else
        [event.recurrenceEnd setWeekAndYear:@"-1"];
    
    //On regarde si on a pas déjà un event qui existe pour ce jour
    int countOfEvent = [self getCountOfEventForAchievement:achievement andDay:event.day];
    if (countOfEvent >= 2)
        return @"Un évènement existe déjà pour cette tache";
    
    //On sauvegarde l'event
    [self saveContext];
    return nil;
}

//On regarde si on a un évent qui existe déjà à la date donnée pour une tache donnée
- (BOOL)eventExistForPlayer:(Player *)player atWeekAndYear:(NSString *)weekAndYear forTask:(Task *)task andDay:(NSString *)day
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Event" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"achievement.player.pseudo == %@ && achievement.task.libelle == %@ && achievement.weekAndYear == %@ && day == %@", player.pseudo, task.libelle, weekAndYear, day];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchedObjects count] > 0)
        return YES;
    else
        return NO;
}

//On récupère tous les events
- (NSArray *)getEvents
{
    return [self getAllObjectForEntity:@"Event" andSortWithProperties:nil];
}

//On récupère toutes les récurrence
- (NSArray *)getRecurrenceEnd
{
    return [self getAllObjectForEntity:@"RecurrenceEnd" andSortWithProperties:nil];
}

//On récupère tous les events d'un joueur donné, pour une semaine donnée et un jour donné
- (NSArray *)getEventsForPlayer:(Player *)player atWeekAndYear:(NSString *)weekAndYear andDay:(NSString *)day
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Event" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"achievement.player.pseudo == %@ && (achievement.weekAndYear == %@ || (achievement.weekAndYear < %@ && (recurrenceEnd.weekAndYear == 0 || recurrenceEnd.weekAndYear >= %@))) && day == %@", player.pseudo, weekAndYear, weekAndYear, weekAndYear, day];
    [fetchRequest setPredicate:newPredicate];
    
    //On rajoute un tri sur l'history
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"achievement.task.libelle"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    //On renvoie le tableau de la requète
    return [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

//On récupère tous les events d'un joueur donné, pour une semaine donnée et une catégorie donnée
- (NSArray *)getEventsForPlayer:(Player *)player atWeekAndYear:(NSString *)weekAndYear forCategory:(CategoryTask *)category
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Event" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"achievement.player.pseudo == %@ && (achievement.weekAndYear == %@ || (achievement.weekAndYear < %@ && (recurrenceEnd.weekAndYear == 0 || recurrenceEnd.weekAndYear >= %@))) && achievement.task.category.libelle == %@", player.pseudo, weekAndYear, weekAndYear, weekAndYear, category.libelle];
    [fetchRequest setPredicate:newPredicate];
    
    //On rajoute un tri sur l'history
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"achievement.task.libelle"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    //On renvoie le tableau de la requète
    return [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

//On regarde si on a un évent qui existe dans le futur pour la tache donnée
- (Event *)getEventForPlayer:(Player *)player futureToWeekAndYear:(NSString *)weekAndYear forTask:(Task *)task andDay:(NSString *)day
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Event" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setFetchLimit:1];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"achievement.player.pseudo == %@ && achievement.task.libelle = %@ && achievement.weekAndYear > %@ && recurrenceEnd.weekAndYear != - 1 && day == %@", player.pseudo, task.libelle, weekAndYear, day];
    [fetchRequest setPredicate:newPredicate];
    
    //On rajoute un tri sur l'history
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"achievement.weekAndYear"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchedObjects count] > 0)
        return [fetchedObjects objectAtIndex:0];
    else
        return nil;
}

//On récupère tous les évènements liés à une tache, un jour donnée et une date de fin de récurrence
- (NSArray *)getEventsRecurrentForPlayer:(Player *)player atWeekAndYear:(NSString *)weekAndYear forTask:(Task *)task andDay:(NSString *)day
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Event" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"achievement.player.pseudo == %@ && achievement.task.libelle == %@ && (recurrenceEnd.weekAndYear == 0 || recurrenceEnd.weekAndYear >= %@) && day == %@", player.pseudo, task.libelle, weekAndYear, day];
    [fetchRequest setPredicate:newPredicate];
    
    //On rajoute un tri sur l'history
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"achievement.weekAndYear"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchedObjects count] > 0)
        return fetchedObjects;
    else
        return nil;
}

//On récupère l'event dans le passé le plus proche à celui que l'on crée et qui n'est pas terminé
- (Event *)getAnteriorEventRecurrentForPlayer:(Player *)player closeToWeekAndYear:(NSString *)weekAndYear forTask:(Task *)task andDay:(NSString *)day
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Event" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"achievement.player.pseudo == %@ && achievement.task.libelle == %@ && achievement.weekAndYear <= %@ && (recurrenceEnd.weekAndYear == 0 || recurrenceEnd.weekAndYear >= %@) && day == %@", player.pseudo, task.libelle, weekAndYear, weekAndYear, day];
    [fetchRequest setPredicate:newPredicate];
    
    //On rajoute un tri sur l'history
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"achievement.weekAndYear"
                                                                   ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchedObjects count] > 0)
        return [fetchedObjects objectAtIndex:0];
    else
        return nil;
}

//On récupère tous les events de la tache récurrent dans le futur pour la tache donnée
- (NSArray *)getEventsForPlayer:(Player *)player futureToWeekAndYear:(NSString *)weekAndYear forTask:(Task *)task andDay:(NSString *)day
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Event" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"achievement.player.pseudo == %@ && achievement.task.libelle = %@ && achievement.weekAndYear > %@ && recurrenceEnd.weekAndYear != - 1 && day == %@", player.pseudo, task.libelle, weekAndYear, day];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchedObjects count] > 0)
        return fetchedObjects;
    else
        return nil;
}

//On récupère l'event de l'achievement donnée, au jour donné
- (Event *)getEventForAchievement:(Achievement *)achievement andDay:(NSString *)day forTask:(Task *)task
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Event" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"achievement.player.pseudo == %@ && (achievement.weekAndYear == %@ || (achievement.weekAndYear < %@ && recurrenceEnd.weekAndYear >= 0)) && day == %@ && achievement.task.libelle == %@", achievement.player.pseudo, achievement.weekAndYear, achievement.weekAndYear, day, task.libelle];
    [fetchRequest setPredicate:newPredicate];
    
    //On rajoute un tri sur l'history
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"achievement.task.libelle"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //On renvoie le tableau de la requète
    if ([fetchedObjects count] > 0)
        return [fetchedObjects objectAtIndex:0];
    else
        return nil;
}

//On récupère le nombre d'event de l'achievement donnée, au jour donné
- (int)getCountOfEventForAchievement:(Achievement *)achievement andDay:(NSString *)day
{
    int count = 0;
    for (Event *event in [[achievement events] allObjects])
    {
        if ([event.day isEqualToString:day])
            count ++;
    }
    
    return count;
}

//On récupère tous les events réalisés d'un player donné pour une task donnée.
- (int)getNumberOfEventCheckedForPlayer:(Player *)player forTask:(Task *)task
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Event" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"achievement.player.pseudo == %@ && achievement.task.libelle == %@ && checked == YES", player.pseudo, task.libelle];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    //On renvoie le tableau de la requète
    return (int)[fetchedObjects count];
}

//On récupère tous les events non réalisé par le player pour le jour et la semaine donnée
- (int)getNumberOfEventCheckedForPlayer:(Player *)player forWeekAndYear:(NSString *)weekAndYear andDay:(NSString *)day
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Event" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"achievement.player.pseudo == %@ && achievement.weekAndYear == %@ && day == %@ && checked == YES", player.pseudo, weekAndYear, day];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    //On renvoie le tableau de la requète
    return (int)[fetchedObjects count];
}

//On récupère tous les events non réalisé par le player pour le jour et la semaine donnée
- (int)getNumberOfEventUncheckedForPlayer:(Player *)player forWeekAndYear:(NSString *)weekAndYear andDay:(NSString *)day
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Event" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"achievement.player.pseudo == %@ && ((achievement.weekAndYear == %@ && checked == NO ) || (achievement.weekAndYear < %@ && (recurrenceEnd.weekAndYear == 0 || recurrenceEnd.weekAndYear >= %@))) && day == %@", player.pseudo, weekAndYear, weekAndYear, weekAndYear, day];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    //On renvoie le tableau de la requète
    return (int)[fetchedObjects count];
}


//On supprime l'event donné
- (void)deleteEvent:(Event *)event
{
    [self.dataBaseManager.managedObjectContext deleteObject:event];
    [self saveContext];
}

//On supprime la recurrence donnée
- (void)deleteRecurrenceEnd:(RecurrenceEnd *)recurrenceEnd
{
    [self.dataBaseManager.managedObjectContext deleteObject:recurrenceEnd];
    [self saveContext];
}


#pragma mark - CRUD Player

//On crée le player après avoir fait quelques tests préalable
- (NSString *)createPlayer:(Player *)player
{
    //On vérifie que un pseudo soit rentré
    if ([player.pseudo length] != 0)
    {
        //Si le pseudo n'existe pas déjà
        if ([self getPlayerForPseudo:player.pseudo] == nil)
        {
            //On sauvegarde le player
            [self.dataBaseManager.managedObjectContext insertObject:player];
            [self saveContext];
            return nil;
        }
        else
        {
            //On renvoie un message d'erreur
            return @"Un autre joueur porte déjà ce nom !";
        }
    }
    else
    {
        //On renvoie un message d'erreur
        return @"Veuillez rentrer un pseudo !";
    }
    
    return nil;
}

//On update le player donné après avoir fait quelques tests
- (NSString *)updatePlayer:(Player *)player
{
    NSString *errorMessage = nil;
    
    //On vérifie que un pseudo soit rentré
    if ([player.pseudo length] != 0)
    {
        //Si le pseudo n'existe pas déjà
        if ([self getCountOfPlayerForPseudo:player.pseudo] < 2)
        {
            //On sauvegarde le player
            [self saveContext];
            return nil;
        }
        else
        {
            //On renvoie un message d'erreur
            errorMessage = @"Un autre joueur porte déjà ce nom !";
        }
    }
    else
    {
        //On renvoie un message d'erreur
        errorMessage = @"Veuillez rentrer un pseudo !";
    }
    
    //On fait un rollback sur les modifications
    [self rollback];
    return errorMessage;
}

//On récupère tous les players
- (NSArray *)getPlayers
{
    NSArray *arrayEntities = [self getAllObjectForEntity:@"Player" andSortWithProperties:@"pseudo"];
    
    return arrayEntities;
}

//On récupère le premier player
- (Player *)getFirstPlayer
{
    //On Défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Player" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:1];
    
    //On rajoute un tri sur l'history
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pseudo"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //Si on a des objets on retourne NO
    if (fetchedObjects.count > 0)
        return [fetchedObjects objectAtIndex:0];
    
    return nil;
}

//On récupère tous les players trié pour le type de podium demandé
- (NSArray *)getPlayersSortedByTypeOfPodium:(TypeOfPodium)typeOfPodium
{
    NSArray *arrayPlayer = [self getPlayers];
    NSMutableArray *arrayPlayerSorted = [[NSMutableArray alloc] init];
    NSMutableArray *arrayScoreSorted = [[NSMutableArray alloc] init];
    
    for (Player *player in arrayPlayer)
    {
        int score = 0;
        if (typeOfPodium == SCORE_SEMAINE)
            score = [self getScoreWeekForPlayer:player forWeekAndYear:[DDHelperController getWeekAndYearForDate:[NSDate date]]];
        else if (typeOfPodium == SCORE_TOTAL)
            score = [self getScoreTotalForPlayer:player];
        else
            score = [self getNumberOfTrophyAchievedForPlayer:player];
        
        if ([arrayScoreSorted count] == 0)
        {
            [arrayPlayerSorted addObject:player];
            [arrayScoreSorted addObject:[NSNumber numberWithInt:score]];
        }
        else
        {
            int count = (int)[arrayScoreSorted count];
            for (int i = 0; i < count; i++)
            {
                if ([[arrayScoreSorted objectAtIndex:i] intValue] < score)
                {
                    [arrayPlayerSorted insertObject:player atIndex:i];
                    [arrayScoreSorted insertObject:[NSNumber numberWithInt:score] atIndex:i];
                    break;
                }
                else if (i == [arrayScoreSorted count] - 1 && [[arrayScoreSorted objectAtIndex:i] intValue] > score)
                {
                    [arrayPlayerSorted addObject:player];
                    [arrayScoreSorted addObject:[NSNumber numberWithInt:score]];
                    break;
                }
                else if (i == [arrayScoreSorted count] - 1)
                {
                    [arrayPlayerSorted insertObject:player atIndex:0];
                    [arrayScoreSorted insertObject:[NSNumber numberWithInt:score] atIndex:0];
                    break;
                }
            }
        }
    }
    
    return arrayPlayerSorted;
}

//On récupère tous les players trié en fonction du score qu'ils ont fais la semaine passé
- (NSArray *)getPlayersSortedByTypeScoreLastWeek
{
    NSArray *arrayPlayer = [self getPlayers];
    NSMutableArray *arrayPlayerSorted = [[NSMutableArray alloc] init];
    NSMutableArray *arrayScoreSorted = [[NSMutableArray alloc] init];
    
    for (Player *player in arrayPlayer)
    {
        NSDate *dateNow = [NSDate date];
        int score = 0;
        score = [self getScoreWeekForPlayer:player forWeekAndYear:[DDHelperController getWeekAndYearForDate:[DDHelperController getPreviousWeekForDate:dateNow]]];

        
        if ([arrayScoreSorted count] == 0)
        {
            [arrayPlayerSorted addObject:player];
            [arrayScoreSorted addObject:[NSNumber numberWithInt:score]];
        }
        else
        {
            int count = (int)[arrayScoreSorted count];
            for (int i = 0; i < count; i++)
            {
                if ([[arrayScoreSorted objectAtIndex:i] intValue] < score)
                {
                    [arrayPlayerSorted insertObject:player atIndex:i];
                    [arrayScoreSorted insertObject:[NSNumber numberWithInt:score] atIndex:i];
                    break;
                }
                else if (i == [arrayScoreSorted count] - 1 && [[arrayScoreSorted objectAtIndex:i] intValue] > score)
                {
                    [arrayPlayerSorted addObject:player];
                    [arrayScoreSorted addObject:[NSNumber numberWithInt:score]];
                    break;
                }
                else if (i == [arrayScoreSorted count] - 1)
                {
                    [arrayPlayerSorted insertObject:player atIndex:0];
                    [arrayScoreSorted insertObject:[NSNumber numberWithInt:score] atIndex:0];
                    break;
                }
            }
        }
    }
    
    return arrayPlayerSorted;
}

//On récupère le joueur donné
- (Player *)getPlayerForPseudo:(NSString *)pseudo
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Player" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"pseudo == %@" , pseudo];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //On renvoie le tableau de la requète
    if ([fetchedObjects count] > 0)
        return [fetchedObjects objectAtIndex:0];
    else
        return nil;
}

//Retourne le nombre de player pour un pseudo donné
- (int)getCountOfPlayerForPseudo:(NSString *)pseudo
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Player" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"pseudo == %@" , pseudo];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return (int)[fetchedObjects count];
}

//On récupère le joueur à l'index donné
- (Player *)getPlayerAtIndex:(int)index
{
    NSArray *arrayPlayer = [self getPlayers];
    
    if ([arrayPlayer count] > 0 && [arrayPlayer count] >= (index + 1))
        return [arrayPlayer objectAtIndex:index];
    else
        return nil;
}

//On récupère le score de la semaine courante pour le player
- (int)getScoreWeekForPlayer:(Player *)player forWeekAndYear:(NSString *)weakAndYear
{
    NSArray *arrayAchievement = [self getAchievementsForPlayer:player atWeekAndYear:weakAndYear];
    int scoreWeek = 0;
    
    //On parse le tableau des achievements
    for (Achievement *achievement in arrayAchievement)
    {
        //On parse les event d'un achievement donné
        for (Event *event in [[achievement events] allObjects])
        {
            if ([event.checked boolValue] == YES)
                scoreWeek += [event.achievement.task.point intValue];
        }
    }
    
    return scoreWeek;
}

//On récupère le score total pour le player
- (int)getScoreTotalForPlayer:(Player *)player
{
    NSArray *arrayAchievement = [self getAchievementsForPlayer:player];
    int scoreTotal = 0;
    
    //On parse le tableau des achievements
    for (Achievement *achievement in arrayAchievement)
    {
        //On parse les event d'un achievement donné
        for (Event *event in [[achievement events] allObjects])
        {
            if ([event.checked boolValue] == YES)
                scoreTotal += [event.achievement.task.point intValue];
        }
    }
    
    return scoreTotal;
}

//On récupère le score total pour le player pour la catégorie donnée
- (int)getScoreTotalForPlayer:(Player *)player forCategory:(CategoryTask *)category
{
    NSArray *arrayAchievement = [self getAchievementsForPlayer:player forCategory:category];
    int scoreTotal = 0;
    
    //On parse le tableau des achievements
    for (Achievement *achievement in arrayAchievement)
    {
        //On parse les event d'un achievement donné
        for (Event *event in [[achievement events] allObjects])
        {
            if ([event.checked boolValue] == YES)
                scoreTotal += [event.achievement.task.point intValue];
        }
    }
    
    return scoreTotal;
}


//On supprime le player donné
- (void)deletePlayer:(Player *)player
{
    [self.dataBaseManager.managedObjectContext deleteObject:player];
    [self saveContext];
}


#pragma mark - CRUD Reward

//On sauvegarde le reward après avoir fait quelques tests préalable
- (NSString *)createReward:(Reward *)reward
{
    //On sauvegarde le trophy
    [self saveContext];
    return nil;
}

//On update la reward donnée
- (void)updateReward:(Reward *)reward
{
    //On sauvegarde la reward
    [self saveContext];
}

//On tri le tableau de rewards
- (NSArray *)getRewardSortedForWeekAndYear:(NSString *)weekAndYear
{
    //On crée le tableau de rewards et on les récupère dans le bon ordre
    NSMutableArray *arrayTrophiesSort = [[NSMutableArray alloc] init];
    
    if ([self getRewardForType:@"Or" forWeekAndYear:weekAndYear] != nil)
        [arrayTrophiesSort addObject:[self getRewardForType:@"Or" forWeekAndYear:weekAndYear]];
    else
        [arrayTrophiesSort addObject:[NSNull null]];
    
    if ([self getRewardForType:@"Argent" forWeekAndYear:weekAndYear] != nil)
        [arrayTrophiesSort addObject:[self getRewardForType:@"Argent" forWeekAndYear:weekAndYear]];
    else
        [arrayTrophiesSort addObject:[NSNull null]];
    
    if ([self getRewardForType:@"Bronze" forWeekAndYear:weekAndYear] != nil)
        [arrayTrophiesSort addObject:[self getRewardForType:@"Bronze" forWeekAndYear:weekAndYear]];
    else
        [arrayTrophiesSort addObject:[NSNull null]];
    
    return arrayTrophiesSort;
}

//On récupère le reward pour le type donnée et la weekAndYear donnée
- (Reward *)getRewardForType:(NSString *)type forWeekAndYear:(NSString *)weekAndYear
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Reward" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"type == %@ && weekAndYear == %@" , type, weekAndYear];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //On renvoie la première donnée de la requète
    if ([fetchedObjects count] > 0)
        return [fetchedObjects objectAtIndex:0];
    else
        return nil;
}

//On supprime le reward donné
- (void)deleteReward:(Reward *)reward
{
    [self.dataBaseManager.managedObjectContext deleteObject:reward];
    [self saveContext];
}


#pragma mark - CRUD Task

//On crée la task après avoir fait quelques tests préalable
- (NSString *)createTask:(Task *)task forCategory:(CategoryTask *)categoryTask withTrophies:(NSArray *)arrayTrophies
{
    NSString *errorMessage = nil;
    
    //On parse les trophies pour voir s'ils sont tous bon
    for (Trophy *trophy in arrayTrophies)
    {
        errorMessage = [self createTrophy:trophy];
        if (errorMessage != nil)
        {
            [self rollback];
            return errorMessage;
        }
    }
    
    if ([task.libelle length] != 0 && task.point != nil)
    {
        //On fait les tests sur la tache
        if ([self getTaskWithLibelle:task.libelle] == nil)
        {
            //On rajoute le context à la task
            [self.dataBaseManager.managedObjectContext insertObject:task];
            
            //On rajoute la catégory à la task
            [task setCategory:categoryTask];
            
            //On ajoute les trophies
            [task addTrophies:[NSSet setWithArray:arrayTrophies]];
            
            //On sauvegarde la task ainsi que les trophies
            [self saveContext];
            return nil;
        }
        else
            return @"Une autre tache porte déjà ce nom!";
    }
    else
        return @"Veuillez remplir tous les champs liés à la tache !";
    
    return nil;
}

//On update la task donnée après avoir fait quelques tests
- (NSString *)updateTask:(Task *)task
{
    NSString *errorMessage = nil;
    
    //On parse les trophies pour voir s'ils sont tous bon
    for (Trophy *trophy in [[task trophies] allObjects])
    {
        errorMessage = [self updateTrophy:trophy];
        if (errorMessage != nil)
        {
            [self rollback];
            return errorMessage;
        }
    }
    
    if ([task.libelle length] != 0 && task.point != nil)
    {
        //On fait les tests sur la tache
        if ([self getCountOfTaskWithLibelle:task.libelle] < 2)
        {
            //On sauvegarde la task ainsi que les trophies
            [self saveContext];
            return nil;
        }
        else
            return @"Une autre tache porte déjà ce nom!";
    }
    else
        return @"Veuillez remplir tous les champs liés à la tache !";
    
    return nil;
}

//On récupère tous les tasks
- (NSArray *)getTasks
{
    return [self getAllObjectForEntity:@"Task" andSortWithProperties:nil];
}

//On récupère les tasks d'une categoryTask
- (NSArray *)getTasksForCategory:(CategoryTask *)category
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Task" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"category.libelle == %@", category.libelle];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //Si on a des tasks, on les tries par libelle
    if (fetchedObjects.count > 0)
    {
        fetchedObjects = [fetchedObjects sortedArrayUsingComparator:^NSComparisonResult(Task *obj1, Task *obj2) {
            return (NSComparisonResult)[obj1.libelle compare:obj2.libelle];
        }];
    }
    
    //On renvoie le tableau de la requète
    return fetchedObjects;
}

//On récupère le tableau des historique d'utilisation des tasks
- (NSArray *)getArrayHistoriqueTask
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Task" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    [fetchRequest setFetchLimit:10];
    
    //On rajoute un tri sur l'history
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"history"
                                                                   ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //On renvoie le tableau de la requète
    return fetchedObjects;
}

//On récupère la task avec le libellé donné
- (Task *)getTaskWithLibelle:(NSString *)libelle
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Task" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"libelle == %@", libelle];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //Si on a une task, on la renvoie
    if (fetchedObjects.count > 0)
        return [fetchedObjects objectAtIndex:0];
    
    //Sinon on renvoie nil
    return nil;
}

//On renvoie le nombre de task avec le libellé donné
- (int)getCountOfTaskWithLibelle:(NSString *)libelle
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Task" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"libelle == %@", libelle];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //On renvoie le count des tasks
    return (int)[fetchedObjects count];
}

//On supprime la task donnée
- (void)deleteTask:(Task *)task
{
    //on supprime tous les objets liés à la tache (event, récurrence, achievement)
    NSArray *arrayAchievements = [self getAchievementsForTask:task];
    for (Achievement *achievement in arrayAchievements)
    {
        for (Event *event in [achievement.events allObjects])
        {
            [self.dataBaseManager.managedObjectContext deleteObject:event.recurrenceEnd];
            [self.dataBaseManager.managedObjectContext deleteObject:event];
        }
        
        [self.dataBaseManager.managedObjectContext deleteObject:achievement];
    }
    
    for (Trophy *trophy in [task.trophies allObjects])
        [self.dataBaseManager.managedObjectContext deleteObject:trophy];

    [self.dataBaseManager.managedObjectContext deleteObject:task];
    
    [self saveContext];
}

//On remet les taches à 0
- (void)resetTasks
{
    NSArray *arrayCategoryTask = [self getCategoryTasks];
    for (CategoryTask *categoryTask in arrayCategoryTask)
        [self.dataBaseManager.managedObjectContext deleteObject:categoryTask];
    
    NSArray *arrayTasks = [self getTasks];
    for (Task *task in arrayTasks)
        [self.dataBaseManager.managedObjectContext deleteObject:task];
    
    NSArray *arrayAchievements = [self getAchievements];
    for (Achievement *achievement in arrayAchievements)
        [self.dataBaseManager.managedObjectContext deleteObject:achievement];
    
    NSArray *arrayEvents = [self getEvents];
    for (Event *event in arrayEvents)
        [self.dataBaseManager.managedObjectContext deleteObject:event];
    
    NSArray *arrayReccurence = [self getRecurrenceEnd];
    for (RecurrenceEnd *recurrence in arrayReccurence)
        [self.dataBaseManager.managedObjectContext deleteObject:recurrence];
    
    NSArray *arrayTrophy = [self getTrophies];
    for (Trophy *trophy in arrayTrophy)
        [self.dataBaseManager.managedObjectContext deleteObject:trophy];
    
    NSArray *arrayCategoryTrophy = [self getCategoryTrophies];
    for (CategoryTrophy *trophy in arrayCategoryTrophy)
        [self.dataBaseManager.managedObjectContext deleteObject:trophy];
    
    [self saveContext];
    
    //On initialise le parser et on récupère les données
    DDParserXML *parser = [[DDParserXML alloc] init];
    [parser parseXMLFile];
}


#pragma mark - CRUD Trophy

//On crée le trophy après avoir fait quelques tests préalable
- (NSString *)createTrophy:(Trophy *)trophy
{
    if (trophy.iteration != nil)
    {
        //On sauvegarde le trophy
        [self.dataBaseManager.managedObjectContext insertObject:trophy];
        return nil;
    }
    else
        return [NSString stringWithFormat:@"Vous devez renseigner un trophée de %@", trophy.type];
}

//On update le trophy après avoir fait quelques tests préalable
- (NSString *)updateTrophy:(Trophy *)trophy
{
    //On teste juste si on a bien une iteration pour le trophy
    if (trophy.iteration != nil)
    {
        return nil;
    }
    else
        return [NSString stringWithFormat:@"Vous devez renseigner un trophée de %@", trophy.type];
}

//On récupère tous les trophies
- (NSArray *)getTrophies
{
    return [self getAllObjectForEntity:@"Trophy" andSortWithProperties:nil];
}

//On récupère le trophy pour le type donnée
- (Trophy *)getTrophyForType:(NSString *)type inArray:(NSArray *)arrayTrophies
{
    //On parse le tableau pour récupérer le bon trophy
    for (Trophy *trophy in arrayTrophies)
    {
        if ([[trophy type] isEqualToString:type])
            return trophy;
    }
    
    return nil;
}

//On tri le tableau de trophies
- (NSArray *)getTrophiesSortedInArray:(NSArray *)arrayTrophies
{
    //On crée le tableau de trophies et on les récupère dans le bon ordre
    NSMutableArray *arrayTrophiesSort = [[NSMutableArray alloc] init];
    
    [arrayTrophiesSort addObject:[self getTrophyForType:@"Bronze" inArray:arrayTrophies]];
    [arrayTrophiesSort addObject:[self getTrophyForType:@"Argent" inArray:arrayTrophies]];
    [arrayTrophiesSort addObject:[self getTrophyForType:@"Or" inArray:arrayTrophies]];
    
    return arrayTrophiesSort;
}

//On récupère le nombre de trophies réalisés pour un joueur donné
- (int)getNumberOfTrophyAchievedForPlayer:(Player *)player
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Trophy" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre : Récupère les trophées des joueurs qui ont un nombre de réalisation de la tache supérieur à l'itération du trophés
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"ANY task.achievments.player.pseudo == %@ && SUBQUERY(task.achievments, $achievment, ANY $achievment.events.checked == YES).@count >= iteration", player.pseudo];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    //On renvoie le tableau de la requète
    return (int)[fetchedObjects count];
}

//On récupère le nombre de trophies réalisés pour un joueur donné, une catégorie donnée
- (int)getNumberOfTrophyAchievedForPlayer:(Player *)player inCategory:(CategoryTask *)category
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Trophy" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre : Récupère les trophées des joueurs qui ont un nombre de réalisation de la tache supérieur à l'itération du trophés
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"task.category.libelle == %@ AND ANY task.achievments.player.pseudo == %@ && SUBQUERY(task.achievments, $achievment, ANY $achievment.events.checked == YES).@count >= iteration", category.libelle, player.pseudo];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    //On renvoie le tableau de la requète
    return (int)[fetchedObjects count];
}

//On récupère le nombre de trophies réalisés pour un joueur donné, une catégorie donnée et un type de trophé donné
- (int)getNumberOfTrophyAchievedForPlayer:(Player *)player inCategory:(CategoryTask *)category andType:(NSString *)type
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Trophy" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre : Récupère les trophées des joueurs qui ont un nombre de réalisation de la tache supérieur à l'itération du trophés
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"type == %@ AND task.category.libelle == %@ AND ANY task.achievments.player.pseudo == %@ && SUBQUERY(task.achievments, $achievment, ANY $achievment.events.checked == YES).@count >= iteration", type, category.libelle, player.pseudo];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    //On renvoie le tableau de la requète
    return (int)[fetchedObjects count];
}

//On supprime le trophy donné
- (void)deleteTrophy:(Trophy *)trophy
{
    [self.dataBaseManager.managedObjectContext deleteObject:trophy];
    [self saveContext];
}

@end
