//
//  DDMenuView.h
//  iTaskFamily
//
//  Created by Damien DELES on 20/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPlayerListViewController.h"

@class DDPopOverViewController;
@class Player;

@protocol DDMenuViewProtocol <NSObject>

//On affiche la page d'accueil
- (void)openHomePage;

//On affiche la page des joueurs
- (void)openPlayerPageWithSens:(int)sens;

//On affiche la page des taches
- (void)openTaskPageWithSens:(int)sens;

//On affiche la page des podiums
- (void)openPodiumPageWithSens:(int)sens;

//On affiche la page des settings
- (void)openSettingPage;

@end


@interface DDMenuView : UIView <DDPlayerListViewProtocol>


#pragma mark - Variables

//Image view de la sélection
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelection;

//Image view de la barre de gauche
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLeftBar;

//Image view du background du joueur
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackgroundPlayer;

//Bouton de sélection du joueur
@property (weak, nonatomic) IBOutlet UIButton *buttonPlayer;

//Delegate de la vue de menu
@property (weak, nonatomic) id<DDMenuViewProtocol> delegate;

//PopOver de la vue
@property (strong, nonatomic) DDPopOverViewController *popOverViewController;

//ViewController de la liste de joueur
@property (strong, nonatomic) DDPlayerListViewController *playerListViewController;

//Joueur principal
@property (strong, nonatomic) Player *currentPlayer;


#pragma mark - Functions

//On switche sur la Home view
- (IBAction)onPushHomeButton:(UIButton *)sender;

//On switche sur la Player view
- (IBAction)onPushPlayerButton:(UIButton *)sender;

//On switche sur la Task view
- (IBAction)onPushTaskButton:(UIButton *)sender;

//On switche sur la Trophy view
- (IBAction)onPushTrophyButton:(UIButton *)sender;

//On switche sur la Setting view
- (IBAction)onPushSettingButton:(UIButton *)sender;

//On ouvre la popUp pour changer de joueur
- (IBAction)onPushSelectPlayerButton:(UIButton *)sender;

@end
