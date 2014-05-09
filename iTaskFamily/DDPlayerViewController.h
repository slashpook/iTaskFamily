//
//  DDPlayerViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 25/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPlayerManagerViewController.h"

@class DDPopOverViewController;
@class DDRootTrophyViewController;

@interface DDPlayerViewController : UIViewController <DDPlayerManagerViewProtocol, UIAlertViewDelegate>


#pragma mark - Variables

//Vue des players miniatures
@property (weak, nonatomic) IBOutlet UIView *viewPlayerMiniature;

//ImageView de fond des boutons de gestion des joueurs
@property (weak, nonatomic) IBOutlet UIView *viewBackgroundPlayerAction;

//ScrollView des miniatures
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewMiniature;

//Bouton pour supprimer un joueur
@property (weak, nonatomic) IBOutlet UIButton *buttonRemovePlayer;

//Bouton pour mettre à jour un joueur
@property (weak, nonatomic) IBOutlet UIButton *buttonUpdatePlayer;

//ImageView du profil du joueur
@property (weak, nonatomic) IBOutlet UIImageView *imageViewProfil;

//Label du nom du joueur courant
@property (weak, nonatomic) IBOutlet UILabel *labelNameProfil;

//Label titre du nombre de trophées
@property (weak, nonatomic) IBOutlet UILabel *labelTitleNbrTrophy;

//Label titre du score de la semaine
@property (weak, nonatomic) IBOutlet UILabel *labelTitleWeekScore;

//Label titre du score total
@property (weak, nonatomic) IBOutlet UILabel *labelTitleTotalScore;

//Label du nombre de trophées
@property (weak, nonatomic) IBOutlet UILabel *labelNbrTrophy;

//Label du score de la semaine
@property (weak, nonatomic) IBOutlet UILabel *labelWeekScore;

//Label du score total
@property (weak, nonatomic) IBOutlet UILabel *labelTotalScore;

//Vue racine de la section des trophées
@property (weak, nonatomic) IBOutlet UIView *viewRootContainer;

//View qui contient les trophées
@property (weak, nonatomic) IBOutlet UIView *viewContainer;

//Header de la section des trophées
@property (weak, nonatomic) IBOutlet UIView *viewHeaderTrophy;

//Label de la section des trophées
@property (weak, nonatomic) IBOutlet UILabel *labelTitreTrophy;

//PopOver de la vue
@property (strong, nonatomic) DDPopOverViewController *popOverViewController;

//Navigation controller pour la gestion du player
@property (strong, nonatomic) UINavigationController *navigationPlayerManagerViewController;

//Vue pour manager les joueurs (création et édition)
@property (strong, nonatomic) DDPlayerManagerViewController *playerManagerViewController;

//Root view des trophées du joueur
@property (strong, nonatomic) UINavigationController *rootTrophyNavigationViewController;

//tableau des joueurs
@property (strong, nonatomic) NSMutableArray *arrayPlayer;

//On récupère le joueur sélectionné
@property (strong, nonatomic) Player *currentPlayer;


#pragma mark - Fonctions

//On appuie sur l'ajout de joueur
- (IBAction)onPushAddPlayer:(id)sender;

//On appuie sur le bouton pour supprimer le joueur sélectionné
- (IBAction)onPushDeletePlayer:(id)sender;

//On appuie sur la modification du joueur
- (IBAction)onPushModifyPlayer:(id)sender;

//On appuie sur l'image de profil
- (IBAction)onPushImageProfil:(id)sender;

@end
