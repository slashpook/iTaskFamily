//
//  DDEventInfosViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 02/03/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Event;

@interface DDEventInfosViewController : UIViewController


#pragma mark - Variables

//TableView des évènements
@property (weak, nonatomic) IBOutlet UITableView *tableViewEvents;

//Label du nom de la tache sélectionné
@property (weak, nonatomic) IBOutlet UILabel *labelTask;

//ImageView de la séparation
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSeparation;

//ImageView de la catégorie
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCategory;

//Label du nom de la catégorie de la tache
@property (weak, nonatomic) IBOutlet UILabel *labelCategory;

//ImageView des points de la tache
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPoints;

//Label des points de la tache
@property (weak, nonatomic) IBOutlet UILabel *labelPoint;

//ImageView de la récurrence de la tache
@property (weak, nonatomic) IBOutlet UIImageView *imageViewRepetition;

//TextView des commentaires de la tache
@property (weak, nonatomic) IBOutlet UITextView *textViewComment;

//Tableau des évènements
@property (strong, nonatomic) NSMutableArray *arrayEvent;

//Evènement sélectionné
@property (strong, nonatomic) Event *currentEvent;


#pragma mark - Fonctions

//On set le tableau d'event pour le jour sélectionné
- (void)getEventsForDay:(NSString *)currentDay;

@end
