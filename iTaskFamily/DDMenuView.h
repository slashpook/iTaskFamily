//
//  DDMenuView.h
//  iTaskFamily
//
//  Created by Damien DELES on 20/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

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


@interface DDMenuView : UIView


#pragma mark - Variables

//Image view de la sélection
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelection;

//Image view de la barre de gauche
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLeftBar;

//Delegate de la vue de menu
@property (weak, nonatomic) id<DDMenuViewProtocol> delegate;


#pragma mark - Functions

//Switch on Home view
- (IBAction)onPushHomeButton:(UIButton *)sender;

//Switch on Player view
- (IBAction)onPushPlayerButton:(UIButton *)sender;

//Switch on Task view
- (IBAction)onPushTaskButton:(UIButton *)sender;

//Switch on Trophy view
- (IBAction)onPushTrophyButton:(UIButton *)sender;

//Switch on Setting view
- (IBAction)onPushSettingButton:(UIButton *)sender;

@end
