//
//  DDPodiumViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 09/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDPodiumViewController.h"

@interface DDPodiumViewController ()

@end

@implementation DDPodiumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //On set le background de la vue
    [[self view] setBackgroundColor:COULEUR_BACKGROUND];
    
    //On configure la ScrollView
    [self.scrollViewPodium setBackgroundColor:COULEUR_WHITE];
    [self.viewBackgroundPodium.layer setCornerRadius:10.0];
    [self.viewBackgroundPodium.layer setMasksToBounds:YES];
    
    //On configure les labels et les boutons de la vue
    [self.viewBackgroundTopBar setBackgroundColor:COULEUR_BLACK];
    [[self.buttonScoreSemaineEnCours titleLabel] setTextColor:COULEUR_WHITE];
    [[self.buttonScoreSemaineEnCours titleLabel] setFont:POLICE_TITLE];
    [[self.buttonScoreSemainePrecedente titleLabel] setTextColor:COULEUR_WHITE];
    [[self.buttonScoreSemainePrecedente titleLabel] setFont:POLICE_TITLE];
    [[self.buttonNombreTotalTrophees titleLabel] setTextColor:COULEUR_WHITE];
    [[self.buttonNombreTotalTrophees titleLabel] setFont:POLICE_TITLE];
    [self.imageViewSelection setBackgroundColor:COULEUR_PODIUM];
    
    //On configure le pageControl
    if ([self.pageControlPodium respondsToSelector:@selector(setTintColor:)])
    {
        [self.pageControlPodium setTintColor:COULEUR_BLACK];
        [self.pageControlPodium setCurrentPageIndicatorTintColor:COULEUR_PODIUM];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Controller fonctions

//On appuie sur le menu
- (IBAction)onPushButtonMenu:(id)sender
{
    //On met à jour la section sélectionnée
    if (sender == self.buttonScoreSemaineEnCours)
        self.pageControlPodium.currentPage = 0;
    else if (sender == self.buttonScoreSemainePrecedente)
        self.pageControlPodium.currentPage = 1;
    else
        self.pageControlPodium.currentPage = 2;
    
    [self refreshScrollView];
}

//On appuie sur le pageControl
- (IBAction)onPushPageControl:(id)sender
{
    if (self.pageControlPodium.currentPage == 0)
        [self onPushButtonMenu:self.buttonScoreSemaineEnCours];
    else if (self.pageControlPodium.currentPage == 1)
        [self onPushButtonMenu:self.buttonScoreSemainePrecedente];
    else
        [self onPushButtonMenu:self.buttonNombreTotalTrophees];
    
    [self refreshScrollView];
}

//On rafraichis la scrollView
-(void)refreshScrollView
{
    CGRect frame = self.scrollViewPodium.frame;
    frame.origin.x = frame.size.width * self.pageControlPodium.currentPage;
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollViewPodium setContentOffset:CGPointMake(frame.origin.x, 0)];
    }];
}


#pragma mark - Fonctions de gestion de l'UIPageControl et UIScrollView

//On appelle la fonction pour rafraichir le page control et la scroll view
-(void)refreshPageControl
{
//    //On change la largeur de la scrollview pour qu'elle corresponde au nombre de données qu'il va contenir
//    self.scrollViewPodium.contentSize = CGSizeMake(self.scrollViewPodium.frame.size.width * [self.arrayPodium count], 0);
//    
//    //On donne à notre page control le nombre de page dont il aura besoin et quelle image on affiche
//    self.pageControl.numberOfPages = [self.arrayPodium count];
//    CGFloat pageWidth = self.scrollView.frame.size.width;
//    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    self.pageControl.currentPage = page;
}

@end
