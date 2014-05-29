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
@class DDCustomButton;
@class DDCustomButtonNotification;

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
@property (weak, nonatomic) IBOutlet DDCustomButton *buttonAddPlayer;

//Boutton pour ajouter un évent quand il y en a aucun
@property (weak, nonatomic) IBOutlet DDCustomButton *buttonBigAddEvent;

//Boutton pour revenir sur la semaine en cours
@property (weak, nonatomic) IBOutlet DDCustomButton *buttonToday;

//Boutton du Lundi
@property (weak, nonatomic) IBOutlet DDCustomButtonNotification *buttonLundi;

//Boutton du Mardi
@property (weak, nonatomic) IBOutlet DDCustomButtonNotification *buttonMardi;

//Boutton du Mercredi
@property (weak, nonatomic) IBOutlet DDCustomButtonNotification *buttonMercredi;

//Boutton du Jeudi
@property (weak, nonatomic) IBOutlet DDCustomButtonNotification *buttonJeudi;

//Boutton du Vendredi
@property (weak, nonatomic) IBOutlet DDCustomButtonNotification *buttonVendredi;

//Boutton du Samedi
@property (weak, nonatomic) IBOutlet DDCustomButtonNotification *buttonSamedi;

//Boutton du Dimanche
@property (weak, nonatomic) IBOutlet DDCustomButtonNotification *buttonDimanche;

//Tableau pour stocker toutes les notifications et les manipuler plus facilement
@property (strong, nonatomic) NSArray *arrayWeekNotification;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewPlus;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPostionXImagePlus;

#pragma mark - Fonctions

//On met à jour les composants en fonctions des joueurs
- (void)updateComponent;

//On se positionne sur le bon jour
- (void)updatePositionOfSelectedDay;

//On met à jour les notifications
- (void)updateNotifications;

//On appuie sur un des boutons
- (IBAction)onPushDayButton:(id)sender;

//On appuie sur le bouton pour ajouter un évènement
- (IBAction)onPushAddEventButton:(id)sender;

//On appuie sur le bouton pour ajouter un joueur
- (IBAction)onPushAddPlayerButton:(id)sender;


@end
