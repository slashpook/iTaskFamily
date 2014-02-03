//
//  DDPodiumViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 31/01/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDAwardViewController.h"

@class DDHistogramView;
@class DDPopOverViewController;

@interface DDPodiumViewController : UIViewController <DDAwardViewProtocol>


#pragma mark - Variables

//Vue histogramme du premier joueur
@property (weak, nonatomic) IBOutlet DDHistogramView *viewPremier;

//Image du profil du premier joueur
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPremier;

//Label du score du premier joueur
@property (weak, nonatomic) IBOutlet UILabel *labelScorePremier;

//Label du nom du premier
@property (weak, nonatomic) IBOutlet UILabel *labelNomPremier;

//Vue de separation des points et du titre pour le premier
@property (weak, nonatomic) IBOutlet UIView *viewSeparationPremier;

//Label du titre pour le premier
@property (weak, nonatomic) IBOutlet UILabel *labelTitrePremier;

//Label de l'exposant tu titre du premier
@property (weak, nonatomic) IBOutlet UILabel *labelTitrePremierExposant;

//Vue histogramme du second joueur
@property (weak, nonatomic) IBOutlet DDHistogramView *viewSecond;

//Image du profil du second joueur
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSecond;

//Label du score du second joueur
@property (weak, nonatomic) IBOutlet UILabel *labelScoreSecond;

//Label du nom du second
@property (weak, nonatomic) IBOutlet UILabel *labelNomSecond;

//Vue de separation des points et du titre pour le second
@property (weak, nonatomic) IBOutlet UIView *viewSeparationSecond;

//Label du titre pour le second
@property (weak, nonatomic) IBOutlet UILabel *labelTitreSecond;

//Label de l'exposant tu titre du second
@property (weak, nonatomic) IBOutlet UILabel *labelTitreSecondExposant;

//Vue histogramme du troisième joueur
@property (weak, nonatomic) IBOutlet DDHistogramView *viewTroisieme;

//Image du profil du troisième joueur
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTroisieme;

//Label du score du troisième joueur
@property (weak, nonatomic) IBOutlet UILabel *labelScoreTroisieme;

//Label du nom du troisieme
@property (weak, nonatomic) IBOutlet UILabel *labelNomTroisieme;

//Vue de separation des points et du titre pour le troisième
@property (weak, nonatomic) IBOutlet UIView *viewSeparationTroisieme;

//Label du titre pour le troisième
@property (weak, nonatomic) IBOutlet UILabel *labelTitreTroisieme;

//Label de l'exposant tu titre du troisième
@property (weak, nonatomic) IBOutlet UILabel *labelTitreTroisiemeExposant;

//Tableau des composants du podium par place
@property (strong, nonatomic) NSArray *arrayComponents;

//Couleur du graphe
@property (strong, nonatomic) UIColor *colorProgressView;

//Bouton pour ajouter des récompenses
@property (weak, nonatomic) IBOutlet UIButton *buttonAddReward;

//PopOver de la vue
@property (strong, nonatomic) DDPopOverViewController *popOverViewController;

//AwardViewController pour rajouter des récompenses
@property (strong, nonatomic) DDAwardViewController *awardViewController;

//Navigation controller qui contient le awardViewController
@property (strong, nonatomic) UINavigationController *navigationAwardController;


#pragma mark - Fonctions

//Fonctions pour mettre à jour les composants
- (void)updateComponentsAndDisplayProgressBar:(BOOL)display;

//Fonction pour ajouter une récompense
- (IBAction)onPushAddAward:(id)sender;

@end
