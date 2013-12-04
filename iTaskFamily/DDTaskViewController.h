//
//  DDTaskViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 04/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Categories;

@interface DDTaskViewController : UIViewController


#pragma mark - Variables

//Vue des categories miniatures
@property (weak, nonatomic) IBOutlet UIView *viewCategoriesMiniature;

//ImageView de fond des boutons de gestion des taches
@property (weak, nonatomic) IBOutlet UIView *viewBackgroundTachesAction;

//ScrollView des miniatures
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewMiniature;

//Bouton pour supprimer une tache
@property (weak, nonatomic) IBOutlet UIButton *buttonRemoveTask;

//Bouton pour mettre à jour une tache
@property (weak, nonatomic) IBOutlet UIButton *buttonUpdateTask;

//Tableau des catégories
@property (strong, nonatomic) NSMutableArray *arrayCategories;

//Categorie courante
@property (strong, nonatomic) Categories *currentCategorie;

//Vue contenant la tableView
@property (weak, nonatomic) IBOutlet UIView *viewBackgroundTableView;

//Header de la categorie sélectionné
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeader;

//Label du nom de la catégorie sélectionné
@property (weak, nonatomic) IBOutlet UILabel *labelCategory;

//TableView pour afficher les taches d'une categorie
@property (weak, nonatomic) IBOutlet UITableView *tableViewCategorie;


#pragma mark - Fonctions

@end
