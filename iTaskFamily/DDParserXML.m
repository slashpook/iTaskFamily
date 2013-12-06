//
//  DDParserXML.m
//  ITaskFamily
//
//  Created by DAMIEN DELES on 20/12/11.
//  Copyright (c) 2011 INGESUP. All rights reserved.
//

#import "DDParserXML.h"
#import "Trophy.h"
#import "Task.h"
#import "Categories.h"
#import "Realisation.h"

@implementation DDParserXML


#pragma mark - Fonctions de base

- (id)init {
    self = [super init];
    if (self) {
        _taskArray = [[NSMutableArray alloc] init];
        _tropheesArray = [[NSMutableArray alloc] init];
        _realisationArray = [[NSMutableArray alloc] init];
        _currentElement = [[NSMutableString alloc] init];
         [self setFirstOpen:true];
    }
    return self;
}

//On pare le fichier XML
- (void)parseXMLFile
{
    if (self.firstOpen == true)
    {        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"xml"];
        NSData *myData = [NSData dataWithContentsOfFile:filePath];
        if ( myData ) { 
            self.parser = [[NSXMLParser alloc] initWithData:myData];
            [self.parser setDelegate:self];
            [self.parser parse];
            [self setFirstOpen:false];
        }
    }
}

// Document handling methods
//Le parser à ouvert le doc
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    [self.taskArray removeAllObjects];
    [self.tropheesArray removeAllObjects];
    [self.realisationArray removeAllObjects];
}

//BALISE OUVRANTE
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    [self.currentElement setString:elementName];
    
    //Si on est sur une balise category
    if ([self.currentElement isEqualToString:@"category"])
    {
        //On crée une nouvelle category
        _category = [NSEntityDescription
                       insertNewObjectForEntityForName:@"Categories"
                       inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
        self.category.name = [attributeDict objectForKey:@"name"];
    }
    
    //Si on est sur un trophées
    if ([self.currentElement isEqualToString:@"trophy"])
    {
        //On crée un nouveau trophée
        Trophy *trophees = [NSEntityDescription
                 insertNewObjectForEntityForName:@"Trophy"
                 inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
        trophees.name = [attributeDict objectForKey:@"name"];
        trophees.type = [attributeDict objectForKey:@"type"];
        trophees.categories = self.category;
        
        //On ajoute le trophées au tableau
        [[self tropheesArray] addObject:trophees];
    }
    
    //Si on est sur une tache
    if ([self.currentElement isEqualToString:@"task"])
    {
        //On crée une nouvelle tache
        _task = [NSEntityDescription
                 insertNewObjectForEntityForName:@"Task"
                 inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
        
        self.task.name = [attributeDict objectForKey:@"name"];
        self.task.point = [NSNumber numberWithInt:[[attributeDict objectForKey:@"point"] intValue]];
        self.task.categories = self.category;
        
        //On ajoute la tache au tableau
        [self.taskArray addObject:self.task];
    }
    
    //Si on est sur une realisation
    if ([self.currentElement isEqualToString:@"realisation"])
    {
        //On crée une nouvelle réalisation
        Realisation *realisation = [NSEntityDescription
                     insertNewObjectForEntityForName:@"Realisation"
                     inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
        realisation.total = [NSNumber numberWithInt:[[attributeDict objectForKey:@"total"] intValue]];
        realisation.type = [attributeDict objectForKey:@"type"];
        
        //On ajoute la réalisation au tableau
        [self.realisationArray addObject:realisation];
    }
}

//STRING TROUVÉ
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{

}

- (void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString
{
    
}

//BALISE FERMANTE
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    [self.currentElement setString:elementName];

    //On rajoute toutes les taches aux trophées
    if ([self.currentElement isEqualToString:@"category"])
    {
        //On set les trophées
        [self.category setTask:[NSSet setWithArray:self.taskArray]];
        [self.category setTrophy:[NSSet setWithArray:self.tropheesArray]];

        //On sauvegarde les données
        [[DDDatabaseAccess instance] saveContext:nil];
        
        [[self tropheesArray] removeAllObjects];
        [[self taskArray] removeAllObjects];
    }
    
    //On rajoute toutes les réalisations à la tache
    if ([self.currentElement isEqualToString:@"task"])
    {
        [self.task setRealisation:[NSSet setWithArray:self.realisationArray]];
        [[self realisationArray] removeAllObjects];
    }
}

//ERREUR
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"    parseErrorOccurred %@",parseError);
    
}

//FIN DU DOC
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    
}

@end
