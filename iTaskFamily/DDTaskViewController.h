//
//  DDTaskViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 04/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDTaskManagerViewController.h"

@class DDPopOverViewController;
@class Categories;
@class Task;
@class Player;
@class DDCustomProgressBar;

@interface DDTaskViewController : UIViewController <DDTaskManagerViewProtocol>


#pragma mark - Variables

//Task sélectionnée
@property (strong, nonatomic) Player *currentPlayer;

//Tableau des catégories
@property (strong, nonatomic) NSMutableArray *arrayCategories;

//Categorie courante
@property (strong, nonatomic) Categories *currentCategorie;

//Task sélectionnée
@property (strong, nonatomic) Task *currentTask;

//PopOver de la vue
@property (strong, nonatomic) DDPopOverViewController *popOverViewController;

//Navigation controller pour la gestion du player
@property (strong, nonatomic) UINavigationController *navigationTaskManagerViewController;

//Vue pour manager les joueurs (création et édition)
@property (strong, nonatomic) DDTaskManagerViewController *taskManagerViewController;

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

//Vue contenant la tableView
@property (weak, nonatomic) IBOutlet UIView *viewBackgroundTableView;

//Label pour afficher si on a une tache ou non
@property (weak, nonatomic) IBOutlet UILabel *labelNoTask;

//Header de la categorie sélectionné
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeaderTableView;

//Label du nom de la catégorie sélectionné
@property (weak, nonatomic) IBOutlet UILabel *labelCategory;

//TableView pour afficher les taches d'une categorie
@property (weak, nonatomic) IBOutlet UITableView *tableViewCategorie;

//Vue background de la section information
@property (weak, nonatomic) IBOutlet UIView *viewBackgroundInformation;

//ImageView header de la section information
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeaderInformation;

//Label titre de la section information
@property (weak, nonatomic) IBOutlet UILabel *labelInformation;

//Label du nom de la tache sélectionnée
@property (weak, nonatomic) IBOutlet UILabel *labelTaskName;

//Image de fond des points de la tache sélectionnée
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackgroundPoint;

//Label du nombre de point de la tache sélecionné
@property (weak, nonatomic) IBOutlet UILabel *labelTaskPoint;

//Label du titre de la section objectif
@property (weak, nonatomic) IBOutlet UILabel *labelObjectif;

//ImageView du joueur sélectionné
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPlayer;

//Label informatif sur les objectifs
@property (weak, nonatomic) IBOutlet UILabel *labelInfoObjectif;

//Label annonçant le nombre de trophés gagnés pour cette catégorie
@property (weak, nonatomic) IBOutlet UILabel *labelNbrTrophy;

//ProgressBar de bronze
@property (weak, nonatomic) IBOutlet DDCustomProgressBar *progressBarBronze;

//Label de réalisation du trophée de bronze
@property (weak, nonatomic) IBOutlet UILabel *labelRealizedBronze;

//Label du nombre total d'occurence à faire pour débloquer le trophée de bronze
@property (weak, nonatomic) IBOutlet UILabel *labelTotalBronze;

//ProgressBar d'argent
@property (weak, nonatomic) IBOutlet DDCustomProgressBar *progressBarArgent;

//Label de réalisation du trophée d'argent
@property (weak, nonatomic) IBOutlet UILabel *labelRealizedArgent;

//Label du nombre total d'occurence à faire pour débloquer le trophée d'argent
@property (weak, nonatomic) IBOutlet UILabel *labelTotalArgent;

//ProgressBar d'or
@property (weak, nonatomic) IBOutlet DDCustomProgressBar *progressBarOr;

//Label de réalisation du trophée d'or
@property (weak, nonatomic) IBOutlet UILabel *labelRealizedOr;

//Label du nombre total d'occurence à faire pour débloquer le trophée d'or
@property (weak, nonatomic) IBOutlet UILabel *labelTotalOr;


#pragma mark - Fonctions

//On ouvre le taskManager pour ajouter une tache
- (IBAction)onPushAddTask:(id)sender;

//On supprime les taches
- (IBAction)onPushRemoveTask:(id)sender;

//On ouvre le taskManger pour modifier une tache
- (IBAction)onPushEditTask:(id)sender;

@end
