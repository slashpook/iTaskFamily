//
//  DDCategoriesListEventViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 21/02/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCustomNavigationBarController.h"
#import "DDTaskEventViewController.h"

@interface DDCategoriesListEventViewController : UIViewController <DDCustomNavBarProtocol>


#pragma mark - Variables

//Navigation bar
@property (strong, nonatomic) DDCustomNavigationBarController *custoNavBar;

//TableView des catégories
@property (weak, nonatomic) IBOutlet UITableView *tableViewCategorie;

//Tableau des catégorie
@property (strong, nonatomic) NSMutableArray *arrayCategory;

//Delegate de la liste des taches
@property (weak, nonatomic) id<DDTaskEventViewProtocol> delegate;

@end
