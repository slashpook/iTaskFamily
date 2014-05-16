//
//  DDEventInfosViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 02/03/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDCustomValidation;

@protocol DDEventInfosProtocol <NSObject>

- (void)updateComponentWithEventSelected;
- (void)addEvent;
- (void)updateEvent;
- (void)removeEvent;

@end

@interface DDEventInfosViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>


#pragma mark - Variables

//Tableau des évènements
@property (strong, nonatomic) NSMutableArray *arrayEvent;

//Evènement sélectionné
@property (strong, nonatomic) Event *currentEvent;

//Delegate de la vue
@property (weak, nonatomic) id<DDEventInfosProtocol> delegate;

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

//ImageView qui affiche le contenu de la récursivité
@property (weak, nonatomic) IBOutlet UIImageView *imageViewContentRepetition;

//TextView des commentaires de la tache
@property (weak, nonatomic) IBOutlet UITextView *textViewComment;

//Vue qui indique si on a validé ou non l'évènement
@property (weak, nonatomic) IBOutlet DDCustomValidation *viewCustomValidation;

//Boutton pour supprimer des évènements
@property (weak, nonatomic) IBOutlet UIButton *buttonDeleteEvent;

//Boutton pour modifier un évènement
@property (weak, nonatomic) IBOutlet UIButton *buttonModifyEvent;


#pragma mark - Fonctions

//On set le tableau d'event pour le jour sélectionné
- (void)getEventsForDay:(NSString *)currentDay;

//On appuie sur le bouton pour supprimer des évènements
- (IBAction)onPushDeleteEventButon:(id)sender;

//On appuie sur le bouton pour modifier un évènement
- (IBAction)onPushModifyEventButton:(id)sender;

//On appuie sur le checkbox
- (IBAction)onPushCheckbox:(UITapGestureRecognizer *)gesture;

@end
