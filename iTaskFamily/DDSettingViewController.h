//
//  DDSettingViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 03/02/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCustomColorViewController.h"
#import "DDAwardViewController.h"
#import "DDMeteoViewController.h"

@class DDPopOverViewController;
@class DDCustomButton;


@interface DDSettingViewController : UIViewController <DDCustomColorViewProtocol, DDAwardViewProtocol, DDMeteoViewProtocol, UIAlertViewDelegate>


#pragma mark - Variables

//PopOver de la vue
@property (strong, nonatomic) DDPopOverViewController *popOverViewController;

//Vue pour changer la couleur de l'appli
@property (strong, nonatomic) DDCustomColorViewController *customColorViewController;

//AwardViewController pour rajouter des récompenses
@property (strong, nonatomic) DDAwardViewController *awardViewController;

//MeteoViewController pour configurer la ville par défault
@property (strong, nonatomic) DDMeteoViewController *meteoViewController;

//Vue de la protection
@property (weak, nonatomic) IBOutlet UIView *viewRecompense;

//Image du header des récompenses
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeaderRecompense;

//Label titre des récompenses
@property (weak, nonatomic) IBOutlet UILabel *labelTitreRecompense;

//Label info des récompenses
@property (weak, nonatomic) IBOutlet UILabel *labelInfoRecompense;

//Un boutton pour créer les récompenses
@property (weak, nonatomic) IBOutlet DDCustomButton *buttonConfigureRecompense;

//Vue de réinitialisation des taches
@property (weak, nonatomic) IBOutlet UIView *viewTask;

//Image du header de la vue de réinitialisation des taches
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeaderTask;

//Label titre de la vue de réinitialisation des taches
@property (weak, nonatomic) IBOutlet UILabel *labelTitreTask;

//Label d'info de la réinitialisation des taches
@property (weak, nonatomic) IBOutlet UILabel *labelInfoTask;

//Bouton de réinitialisation des taches
@property (weak, nonatomic) IBOutlet DDCustomButton *buttonResetTask;

//Vue de la météo
@property (weak, nonatomic) IBOutlet UIView *viewMeteo;

//Image du header de la vue de météo
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeaderMeteo;

//Label titre de la vue météo
@property (weak, nonatomic) IBOutlet UILabel *labelTitreMeteo;

//Label d'info de la vue météo
@property (weak, nonatomic) IBOutlet UILabel *labelInfoMeteo;

//Switch pour configurer la ville de la météo
@property (weak, nonatomic) IBOutlet UISwitch *switchMeteo;

//Bouton pour changer la ville par défaut de la météo
@property (weak, nonatomic) IBOutlet DDCustomButton *buttonChangeVille;

//Vue de setting du thème
@property (weak, nonatomic) IBOutlet UIView *viewTheme;

//Image du header de la vue de setting du thème
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeaderTheme;

//Label titre de la vue de setting du thème
@property (weak, nonatomic) IBOutlet UILabel *labelTitreTheme;

//Label titre theme courant
@property (weak, nonatomic) IBOutlet UILabel *labelThemeCourant;

//View couleur sélectionné
@property (weak, nonatomic) IBOutlet UIView *viewCurrentColor;

//Label choix de la couleur
@property (weak, nonatomic) IBOutlet UILabel *labelChoiceColor;

//Boutton couleur 1
@property (weak, nonatomic) IBOutlet UIButton *buttonColor1;

//Boutton couleur 2
@property (weak, nonatomic) IBOutlet UIButton *buttonColor2;

//Boutton couleur 3
@property (weak, nonatomic) IBOutlet UIButton *buttonColor3;

//Boutton couleur 4
@property (weak, nonatomic) IBOutlet UIButton *buttonColor4;

//Boutton couleur 5
@property (weak, nonatomic) IBOutlet UIButton *buttonColor5;

//Boutton couleur 6
@property (weak, nonatomic) IBOutlet UIButton *buttonColor6;

//Boutton couleur 7
@property (weak, nonatomic) IBOutlet UIButton *buttonColor7;

//Boutton couleur 8
@property (weak, nonatomic) IBOutlet UIButton *buttonColor8;

//Boutton couleur 9
@property (weak, nonatomic) IBOutlet UIButton *buttonColor9;

//Boutton couleur 10
@property (weak, nonatomic) IBOutlet UIButton *buttonColor10;

//Boutton couleur 11
@property (weak, nonatomic) IBOutlet UIButton *buttonColor11;

//Boutton couleur 12
@property (weak, nonatomic) IBOutlet UIButton *buttonColor12;

//Boutton pour afficher la pop up pour personnaliser la couleur
@property (weak, nonatomic) IBOutlet DDCustomButton *buttonColorPerso;

//Vue d'affichage du tutoriel
@property (weak, nonatomic) IBOutlet UIView *viewTutoriel;

//Image du header de la vue de tutoriel
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeaderTutoriel;

//Label titre de la vue du tutoriel
@property (weak, nonatomic) IBOutlet UILabel *labelTitreTutoriel;

//Vue d'affichage des achats in app
@property (weak, nonatomic) IBOutlet UIView *viewAchat;

//Image du header de la vue des achats in app
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeaderAchat;

//Label titre de la vue des achats in app
@property (weak, nonatomic) IBOutlet UILabel *labelTitreAchat;

//Boutton pour acheter l'appli
@property (weak, nonatomic) IBOutlet DDCustomButton *buttonAchatInApp;

//Boutton pour restaurer les achats
@property (weak, nonatomic) IBOutlet DDCustomButton *buttonRestaureAchatInApp;


#pragma mark - Fonctions

//Fonction pour ajouter une récompense
- (IBAction)onPushAddAward:(id)sender;

//Fonction pour réinitialiser les taches
- (IBAction)onPushButtonResetTask:(id)sender;

//On appuie sur le switch de la météo
- (IBAction)onPushSwitchMeteo:(id)sender;

//Fonction pour changer la ville par défaut de la météo
- (IBAction)onPushButtonChangeVille:(id)sender;

//Fonction pour changer la couleur de l'appli
- (IBAction)onPushButtonColor:(id)sender;

//Fonction pour ouvrir une popup et choisir une couleur personalisé
- (IBAction)onPushButtonChoiceColorPerso:(id)sender;

@end
