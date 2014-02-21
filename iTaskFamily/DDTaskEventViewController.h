//
//  DDTaskEventViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 21/02/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCustomNavigationBarController.h"

@protocol DDTaskEventViewProtocol <NSObject>

- (void)saveTaskWithTask:(Task *)task;

@end

@interface DDTaskEventViewController : UIViewController <DDCustomNavBarProtocol>


#pragma mark - Variables

//Navigation bar
@property (strong, nonatomic) DDCustomNavigationBarController *custoNavBar;

//TableView des catégories
@property (weak, nonatomic) IBOutlet UITableView *tableViewTask;

//Tableau des catégorie
@property (strong, nonatomic) NSMutableArray *arrayTasks;

//Nom de la catégorie
@property (strong, nonatomic) NSString *category;

//Delegate de la liste des taches
@property (weak, nonatomic) id<DDTaskEventViewProtocol> delegate;


#pragma mark - Fonctions

//On rempli la database avec les taches de la catégorie correspondante
- (void)setDatabaseForCategory:(NSString *)category;

@end
