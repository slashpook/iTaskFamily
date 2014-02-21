//
//  DDEventView.h
//  iTaskFamily
//
//  Created by Damien DELES on 24/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDEventManagerViewController.h"

@class DDPopOverViewController;

@interface DDEventView : UIView <DDEventManagerViewProtocol>


#pragma mark - Variables

//PopOver de la vue
@property (strong, nonatomic) DDPopOverViewController *popOverViewController;

//Navigation controller pour la gestion des évènements
@property (strong, nonatomic) UINavigationController *navigationEventManagerViewController;

//Vue pour manager les évènements (création et édition)
@property (strong, nonatomic) DDEventManagerViewController *eventManagerViewController;

//Header de la vue
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeader;

//Image de sélection du jour
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelection;

//Label d'indication pour savoir si il y a des joueurs ou non
@property (retain, nonatomic) IBOutlet UILabel *labelNoPlayer;

//Boutton du Lundi
@property (retain, nonatomic) IBOutlet UIButton *buttonLundi;

//Boutton du Mardi
@property (retain, nonatomic) IBOutlet UIButton *buttonMardi;

//Boutton du Mercredi
@property (retain, nonatomic) IBOutlet UIButton *buttonMercredi;

//Boutton du Jeudi
@property (retain, nonatomic) IBOutlet UIButton *buttonJeudi;

//Boutton du Vendredi
@property (retain, nonatomic) IBOutlet UIButton *buttonVendredi;

//Boutton du Samedi
@property (retain, nonatomic) IBOutlet UIButton *buttonSamedi;

//Boutton du Dimanche
@property (retain, nonatomic) IBOutlet UIButton *buttonDimanche;


#pragma mark - Fonctions

//On appuie sur un des boutons
- (IBAction)onPushDayButton:(id)sender;

//On appuie sur le bouton pour ajouter un évènement
- (IBAction)onPushAddEventButton:(id)sender;

//On appuie sur le bouton pour supprimer des évènements
- (IBAction)onPushDeleteEventButon:(id)sender;

//On appuie sur le bouton pour modifier un évènement
- (IBAction)onPushModifyEventButton:(id)sender;

@end
