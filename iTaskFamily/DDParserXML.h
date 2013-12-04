//
//  DDParserXML.h
//  ITaskFamily
//
//  Created by DAMIEN DELES on 20/12/11.
//  Copyright (c) 2011 INGESUP. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Trophy;
@class Task;
@class Categories;
@class Realisation;

@interface DDParserXML : NSObject <NSXMLParserDelegate>


#pragma mark - Variables

//Parser
@property (strong, nonatomic) NSXMLParser *parser;

//Tableau des taches
@property (strong, nonatomic) NSMutableArray *taskArray;

//Tableau des trophées
@property (strong, nonatomic) NSMutableArray *tropheesArray;

//Tableau des réalisation
@property (strong, nonatomic) NSMutableArray *realisationArray;

//Variable pour récupérer une catégorie
@property (strong, nonatomic) Categories *category;

//Variable pour récupérer une tache
@property (strong, nonatomic) Task *task;

//Variable pour connaître l'élément courant
@property (strong, nonatomic) NSMutableString *currentElement;

//Variable pour savoir si c'est la première ouverture ou non
@property (assign, nonatomic) BOOL firstOpen;


#pragma mark - Fonctions

//On parse le fichier XML
- (void)parseXMLFile;

@end
