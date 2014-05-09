//
//  DDDatabaseManager.h
//  DALiTaskFamily
//
//  Created by Damien DELES on 26/04/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDDatabaseManager : NSObject


#pragma mark - Variables

//On retourne le manageObjectContext de l'application
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

//On retourne le manageObject de l'application
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

//Retourne le store coordinator de l'application
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


#pragma mark - Fonctions

//Retourne l'URL du directory de l'application
- (NSURL *)applicationDocumentsDirectory;

//Retourne YES si la base de donnée existe
- (BOOL)databaseExist;

//On sauvegarde le contexte
- (BOOL)saveContext:(NSError *)error;

@end
