//
//  DDRootPodiumViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 09/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDPodiumViewController;

@interface DDRootPodiumViewController : UIViewController


#pragma mark - Variables

//Vue de fond de la scrollview du podium
@property (weak, nonatomic) IBOutlet UIView *viewBackgroundPodium;

//ScrollView du podium
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewPodium;

//PageControl du podium
@property (weak, nonatomic) IBOutlet UIPageControl *pageControlPodium;

//ImageView de sélection de la section de la scrollview
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelection;

//Bouton de la section score en cours
@property (weak, nonatomic) IBOutlet UIButton *buttonScoreSemaineEnCours;

//Bouton de la section score semaine precedente
@property (weak, nonatomic) IBOutlet UIButton *buttonScoreSemainePrecedente;

//Bouton de la section des trophées totaux obtenus
@property (weak, nonatomic) IBOutlet UIButton *buttonNombreTotalTrophees;

//Vue de fond du background
@property (weak, nonatomic) IBOutlet UIView *viewBackgroundTopBar;

//PodiumViewController du score de la semaine en cours
@property (strong, nonatomic) DDPodiumViewController *podiumSemaineEnCours;

//PodiumViewController du score de la semaine précédente
@property (strong, nonatomic) DDPodiumViewController *podiumSemainePrecedente;

//PodiumViewController du nombre de trophées obtenue
@property (strong, nonatomic) DDPodiumViewController *podiumTotalTrophees;

//Array qui contient tous les controllers des podiums
@property (strong, nonatomic) NSArray *arrayPodiums;


#pragma mark - Fonctions

//On appuie sur le menu
- (IBAction)onPushButtonMenu:(id)sender;

//On appuie sur le pageControl
- (IBAction)onPushPageControl:(id)sender;

@end
