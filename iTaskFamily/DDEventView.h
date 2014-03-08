//
//  DDEventView.h
//  iTaskFamily
//
//  Created by Damien DELES on 24/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDEventManagerViewController.h"
#import "DDEventInfosViewController.h"

@class DDPopOverViewController;

@interface DDEventView : UIView <DDEventManagerViewProtocol, DDEventInfosProtocol>


#pragma mark - Variables

//PopOver de la vue
@property (strong, nonatomic) DDPopOverViewController *popOverViewController;

//Navigation controller pour la gestion des évènements
@property (strong, nonatomic) UINavigationController *navigationEventManagerViewController;

//Vue pour manager les évènements (création et édition)
@property (strong, nonatomic) DDEventManagerViewController *eventManagerViewController;

//Controller qui affiche les infos sur les évènements des joueurs
@property (strong, nonatomic) DDEventInfosViewController *eventInfosViewController;

//Récupère le jour sélectionné
@property (strong, nonatomic) NSString *daySelected;

//Booléen pour savoir si on doit animer ou pas
@property (assign, nonatomic) BOOL mustAnimateSelectionDay;

//Header de la vue
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeader;

//Image de sélection du jour
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelection;

//Label d'indication pour savoir si il y a des joueurs ou non
@property (weak, nonatomic) IBOutlet UILabel *labelInfos;

//Boutton du Lundi
@property (weak, nonatomic) IBOutlet UIButton *buttonLundi;

//Boutton du Mardi
@property (weak, nonatomic) IBOutlet UIButton *buttonMardi;

//Boutton du Mercredi
@property (weak, nonatomic) IBOutlet UIButton *buttonMercredi;

//Boutton du Jeudi
@property (weak, nonatomic) IBOutlet UIButton *buttonJeudi;

//Boutton du Vendredi
@property (weak, nonatomic) IBOutlet UIButton *buttonVendredi;

//Boutton du Samedi
@property (weak, nonatomic) IBOutlet UIButton *buttonSamedi;

//Boutton du Dimanche
@property (weak, nonatomic) IBOutlet UIButton *buttonDimanche;

//Boutton pour ajouter un évènement
@property (weak, nonatomic) IBOutlet UIButton *buttonAddEvent;

//Boutton pour supprimer des évènements
@property (weak, nonatomic) IBOutlet UIButton *buttonDeleteEvent;

//Boutton pour modifier un évènement
@property (weak, nonatomic) IBOutlet UIButton *buttonModifyEvent;


#pragma mark - Fonctions

//On met à jour les composants en fonctions des joueurs
- (void)updateComponent;

//On se positionne sur le bon jour
- (void)updatePositionOfSelectedDay;

//On appuie sur un des boutons
- (IBAction)onPushDayButton:(id)sender;

//On appuie sur le bouton pour ajouter un évènement
- (IBAction)onPushAddEventButton:(id)sender;

//On appuie sur le bouton pour supprimer des évènements
- (IBAction)onPushDeleteEventButon:(id)sender;

//On appuie sur le bouton pour modifier un évènement
- (IBAction)onPushModifyEventButton:(id)sender;

@end
