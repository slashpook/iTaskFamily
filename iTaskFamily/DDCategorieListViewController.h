//
//  DDCategorieListViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 06/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCustomNavigationBarController.h"

@protocol DDCategorieListViewProtocol <NSObject>

- (void)closeCategorieViewWithCategorie:(CategoryTask *)categorie;

@end

@interface DDCategorieListViewController : UIViewController <DDCustomNavBarProtocol, UITableViewDataSource, UITableViewDelegate>


#pragma mark - Variables

//TableView des catégories
@property (weak, nonatomic) IBOutlet UITableView *tableViewCategory;

//Tableau des catégorie
@property (strong, nonatomic) NSMutableArray *arrayCategory;

//Custom navigation bar de la vue
@property (strong, nonatomic) DDCustomNavigationBarController *custoNavBar;

//Delegate de la vue
@property (weak, nonatomic) id<DDCategorieListViewProtocol> delegate;

//On garde la couleur de coté
@property (strong, nonatomic) UIColor *couleurBackground;

@end
