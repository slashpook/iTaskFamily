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
#import "DDEventManagerTableViewController.h"

@protocol DDEventManagerViewProtocol <NSObject>

- (void)closeEventManagerView;

@end

@interface DDEventManagerViewController : UIViewController <DDCustomNavBarProtocol, UITextViewDelegate, DDOccurenceViewProtocol, DDTaskEventViewProtocol, DDEventManagerTableViewProtocol, UIAlertViewDelegate>


#pragma mark - Variables

//Delegate de la vue
@property (weak, nonatomic) id<DDEventManagerViewProtocol> delegate;

//Navigation bar
@property (strong, nonatomic) DDCustomNavigationBarController *custoNavBar;

//Vue qui contient le tableViewController
@property (weak, nonatomic) IBOutlet UIView *viewContainer;

//TableView Controller de la vue de management
@property (weak, nonatomic) DDEventManagerTableViewController *tableViewEvent;

//Label titre information
@property (weak, nonatomic) IBOutlet UILabel *labelInformation;

//Label titre commentaire
@property (weak, nonatomic) IBOutlet UILabel *labelCommentaire;

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

//Tache que l'on va ajouter à l'évènement
@property (strong, nonatomic) NSString *weekAndYearSelected;


#pragma mark - Fonctions

//On met à jour les composants
- (void)updateComponent;

@end
