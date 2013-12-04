//
//  DDPlayerView.h
//  iTaskFamily
//
//  Created by Damien DELES on 21/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPlayerListViewController.h"

@class DDPopOverViewController;

@interface DDPlayerView : UIView <UIScrollViewDelegate, DDPlayerListViewProtocol>


#pragma mark - Variables

//Bouton d'ajout de joueur
@property (weak, nonatomic)IBOutlet UIView *viewHeader;

//Bouton d'ajout de joueur
@property (weak, nonatomic)IBOutlet UIView *viewBottom;

//Bouton d'ajout de joueur
@property (weak, nonatomic)IBOutlet UIButton *buttonAddPlayer;

//ScrollView des joueurs
@property (weak, nonatomic)IBOutlet UIScrollView *scrollViewPlayer;

//Label nom du joueur
@property (weak, nonatomic)IBOutlet UILabel *labelNamePlayer;

//Label des points du joueur
@property (weak, nonatomic)IBOutlet UILabel *labelPointPlayer;

//On récupère la référence du page control présent dans le homeView
@property (strong, nonatomic) UIPageControl *pageControl;

//Tableau des joueurs
@property (strong, nonatomic) NSMutableArray *arrayPlayer;

//PopOver de la vue
@property (strong, nonatomic) DDPopOverViewController *popOverViewController;

//Controller de la liste des joueurs
@property (strong, nonatomic) DDPlayerListViewController *playerListViewController;


#pragma mark - Fonctions

//On appuie sur le bouton pour ajouter un joueur
- (IBAction)onPushPlayer:(id)sender;

//On change le joueur quand on appuie sur le page control
- (IBAction)changePlayerInPageControl:(id)sender;

//On appelle la fonction pour rafraichir le page control et la scroll view
- (void)refreshPageControlWithScrollView:(UIScrollView *)scrollView;

@end
