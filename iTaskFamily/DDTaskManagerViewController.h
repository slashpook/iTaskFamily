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

@class Categories;
@class Task;

@protocol DDTaskManagerViewProtocol <NSObject>

- (void)closeTaskManagerView;

@end

@interface DDTaskManagerViewController : UIViewController <DDCustomNavBarProtocol, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, DDCategorieListViewProtocol>


#pragma mark - Variables

//Delegate de la vue
@property (weak, nonatomic) id<DDTaskManagerViewProtocol> delegate;

//On récupère la catégorie en cours
@property (strong, nonatomic) Categories *currentCategory;

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

//TableView des infos de la tache
@property (weak, nonatomic) IBOutlet UITableView *tableViewTaskInfo;

//First cell
@property (strong, nonatomic) IBOutlet UITableViewCell *cell1;

//Label du titre du nom de la tache
@property (weak, nonatomic) IBOutlet UILabel *labelTitleNameTask;

//TextField du nom de la tache
@property (weak, nonatomic) IBOutlet UITextField *textFieldNameTask;

//Second cell
@property (strong, nonatomic) IBOutlet UITableViewCell *cell2;

//Label du titre du nom de la catégorie
@property (weak, nonatomic) IBOutlet UILabel *labelTitleNameCategory;

//Label du nom de la catégorie
@property (weak, nonatomic) IBOutlet UILabel *labelNameCategory;

//Last cell
@property (strong, nonatomic) IBOutlet UITableViewCell *cell3;

//Label du titre du nombre de point
@property (weak, nonatomic) IBOutlet UILabel *labelTitlePoint;

//Label du nombre de point
@property (weak, nonatomic) IBOutlet UITextField *textFieldPoint;

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
