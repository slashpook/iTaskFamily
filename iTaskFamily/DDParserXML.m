//
//  DDParserXML.m
//  ITaskFamily
//
//  Created by DAMIEN DELES on 20/12/11.
//  Copyright (c) 2011 INGESUP. All rights reserved.
//

#import "DDParserXML.h"

@implementation DDParserXML


#pragma mark - Fonctions de base

- (id)init {
    self = [super init];
    if (self) {
        _taskArray = [[NSMutableArray alloc] init];
        _trophyArray = [[NSMutableArray alloc] init];
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
    [self.trophyArray removeAllObjects];
}

//BALISE OUVRANTE
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    [self.currentElement setString:elementName];
    
    //Si on est sur une balise category
    if ([self.currentElement isEqualToString:@"category"])
    {
        //On crée une nouvelle category
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryTask" inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
        _category = [[CategoryTask alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];

        self.category.libelle = [attributeDict objectForKey:@"libelle"];
        
        //On crée la category
        [[DDDatabaseAccess instance] createCategoryTask:self.category];
    }
    
    //Si on est sur un trophées
    if ([self.currentElement isEqualToString:@"trophy"])
    {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryTrophy" inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
        CategoryTrophy *categoryTrophy = [[CategoryTrophy alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
        
        [categoryTrophy setLibelle:[attributeDict objectForKey:@"libelle"]];
        [categoryTrophy setType:[attributeDict objectForKey:@"type"]];
        
        //On crée le categoryTrophy
        [[DDDatabaseAccess instance] createCategoryTrophy:categoryTrophy withCategory:self.category];
    }
    
    //Si on est sur une tache
    if ([self.currentElement isEqualToString:@"task"])
    {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
        _task = [[Task alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
        
        [self.task setLibelle:[attributeDict objectForKey:@"libelle"]];
        [self.task setPoint:[NSNumber numberWithInt:[[attributeDict objectForKey:@"point"] intValue]]];
        
        //On ajoute la tache au tableau
        [self.taskArray addObject:self.task];
    }
    
    //Si on est sur un trophée de tache
    if ([self.currentElement isEqualToString:@"realisation"])
    {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Trophy" inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
        Trophy *trophy = [[Trophy alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
        
        [trophy setIteration:[NSNumber numberWithInt:[[attributeDict objectForKey:@"total"] intValue]]];
        [trophy setType:[attributeDict objectForKey:@"type"]];
        
        //On ajoute le trophy au tableau
        [self.trophyArray addObject:trophy];
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
    
    //On rajoute toutes les réalisations à la tache
    if ([self.currentElement isEqualToString:@"task"])
    {
        [[DDDatabaseAccess instance] createTask:self.task forCategory:self.category withTrophies:self.trophyArray];

        [[self trophyArray] removeAllObjects];
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
