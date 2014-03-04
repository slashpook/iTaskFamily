//
//  DDEventManagerViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 20/02/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCustomNavigationBarController.h"
#import "DDCategoriesListEventViewController.h"
#import "DDOccurenceViewController.h"
#import "DDTaskEventViewController.h"

@class Event;
@class Task;

@protocol DDEventManagerViewProtocol <NSObject>

- (void)closeEventManagerView;

@end

@interface DDEventManagerViewController : UIViewController <DDCustomNavBarProtocol, UITextViewDelegate, DDOccurenceViewProtocol, DDTaskEventViewProtocol>


#pragma mark - Variables

//Delegate de la vue
@property (weak, nonatomic) id<DDEventManagerViewProtocol> delegate;

//Navigation bar
@property (strong, nonatomic) DDCustomNavigationBarController *custoNavBar;

//TableView de l'évènement
@property (weak, nonatomic) IBOutlet UITableView *tableViewElement;

//Label titre information
@property (weak, nonatomic) IBOutlet UILabel *labelInformation;

//Label titre commentaire
@property (weak, nonatomic) IBOutlet UILabel *labelCommentaire;

//Cellule Tache
@property (strong, nonatomic) IBOutlet UITableViewCell *cell1;

//Label titre de la cellule tache
@property (weak, nonatomic) IBOutlet UILabel *labelTacheTitre;

//Label content de la cellule tache
@property (weak, nonatomic) IBOutlet UILabel *labelTacheContent;

//Cellule Date
@property (strong, nonatomic) IBOutlet UITableViewCell *cell2;

//Label titre de la cellule date
@property (weak, nonatomic) IBOutlet UILabel *labelDateTitre;

//Label content de la cellule date
@property (weak, nonatomic) IBOutlet UILabel *labelDateContent;

//Cellule Récurrence
@property (strong, nonatomic) IBOutlet UITableViewCell *cell3;

//Label titre de la cellule récurrence
@property (weak, nonatomic) IBOutlet UILabel *labelRecurrence;

//Switch de la cellule récurrence
@property (weak, nonatomic) IBOutlet UISwitch *switchRecurrence;

//TextView pour mettre des commentaires
@property (weak, nonatomic) IBOutlet UITextView *textViewComment;

//Tableau contenant les jours de l'évènement
@property (strong, nonatomic) NSMutableArray *arrayOccurence;

//Booléen pour modifier l'évènement
@property (assign, nonatomic) BOOL isModifyEvent;

//Evènement que l'on crée ou modifie
@property (strong, nonatomic) Event *eventToModify;

//Tache que l'on va ajouter à l'évènement
@property (strong, nonatomic) Task *task;


#pragma mark - Fonctions

//On met à jour les composants
- (void)updateComponent;

@end
