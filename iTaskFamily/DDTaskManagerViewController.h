//
//  DDTaskManagerViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 05/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDCustomNavigationBarController.h"
#import "DDCategorieListViewController.h"
#import "DDTaskManagerTableViewController.h"

@protocol DDTaskManagerViewProtocol <NSObject>

- (void)closeTaskManagerView;

@end

@interface DDTaskManagerViewController : UIViewController <DDCustomNavBarProtocol, UITextFieldDelegate, DDCategorieListViewProtocol, DDTaskManagerTableViewProtocol>


#pragma mark - Variables

//Delegate de la vue
@property (weak, nonatomic) id<DDTaskManagerViewProtocol> delegate;

//TableView du controller
@property (weak, nonatomic) DDTaskManagerTableViewController *tableViewTask;

//On récupère la catégorie en cours
@property (strong, nonatomic) CategoryTask *currentCategory;

//Booléen pour modifier la tache
@property (assign, nonatomic) BOOL isModifyTask;

//Tache que l'on modifie (si c'est le cas)
@property (strong, nonatomic) Task *task;

//Navigation bar
@property (strong, nonatomic) DDCustomNavigationBarController *custoNavBar;

//Label titre information
@property (weak, nonatomic) IBOutlet UILabel *labelInformations;

//Label titre objectifs
@property (weak, nonatomic) IBOutlet UILabel *labelObjectifs;

//TextField des réalisations de bronze
@property (weak, nonatomic) IBOutlet UITextField *textFieldBronze;

//TextField des réalisations d'argent
@property (weak, nonatomic) IBOutlet UITextField *textFieldArgent;

//TextField des réalisations d'or
@property (weak, nonatomic) IBOutlet UITextField *textFieldOr;


#pragma mark - Fonctions

//On met à jour les composants
- (void)updateComponent;

@end
