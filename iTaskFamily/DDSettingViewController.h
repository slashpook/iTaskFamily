//
//  DDSettingViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 03/02/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDSettingViewController : UIViewController


#pragma mark - Variables

//Vue de la protection
@property (weak, nonatomic) IBOutlet UIView *viewProtection;

//Image du header de la vue protection
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeaderProtection;

//Label titre de la protection
@property (weak, nonatomic) IBOutlet UILabel *labelTitreProtection;

//Label d'info de la protection
@property (weak, nonatomic) IBOutlet UILabel *labelInfoProtection;

//Switch pour configurer le mot de passe
@property (weak, nonatomic) IBOutlet UISwitch *switchPassword;

//Vue de réinitialisation des taches
@property (weak, nonatomic) IBOutlet UIView *viewTask;

//Image du header de la vue de réinitialisation des taches
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeaderTask;

//Label titre de la vue de réinitialisation des taches
@property (weak, nonatomic) IBOutlet UILabel *labelTitreTask;

//Label d'info de la réinitialisation des taches
@property (weak, nonatomic) IBOutlet UILabel *labelInfoTask;

//Bouton de réinitialisation des taches
@property (weak, nonatomic) IBOutlet UIButton *buttonResetTask;

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
@property (weak, nonatomic) IBOutlet UIButton *buttonChangeVille;

//Vue d'affichage du tutoriel
@property (weak, nonatomic) IBOutlet UIView *viewTutoriel;

//Image du header de la vue de tutoriel
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeaderTutoriel;

//Label titre de la vue du tutoriel
@property (weak, nonatomic) IBOutlet UILabel *labelTitreTutoriel;

//ScrollView du tutoriel
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewTutoriel;


#pragma mark - Fonctions

//Fonction pour réinitialiser les taches
- (IBAction)onPushButtonResetTask:(id)sender;

//Fonction pour changer la ville par défaut de la météo
- (IBAction)onPushButtonChangeVille:(id)sender;


@end
