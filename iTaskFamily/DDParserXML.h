//
//  DDParserXML.h
//  ITaskFamily
//
//  Created by DAMIEN DELES on 20/12/11.
//  Copyright (c) 2011 INGESUP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDParserXML : NSObject <NSXMLParserDelegate>


#pragma mark - Variables

//Parser
@property (strong, nonatomic) NSXMLParser *parser;

//Tableau des taches
@property (strong, nonatomic) NSMutableArray *taskArray;

//Tableau des trophées de tache
@property (strong, nonatomic) NSMutableArray *trophyArray;

//Variable pour récupérer une catégorie
@property (strong, nonatomic) CategoryTask *category;

//Variable pour récupérer une tache
@property (strong, nonatomic) Task *task;

//Variable pour connaître l'élément courant
@property (strong, nonatomic) NSMutableString *currentElement;

#pragma mark - Fonctions

//On parse le fichier XML
- (void)parseXMLFile;

@end
