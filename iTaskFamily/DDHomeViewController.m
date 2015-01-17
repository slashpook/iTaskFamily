//
//  DDHomeViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 20/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDHomeViewController.h"
#import "DDPlayerView.h"
#import "DDEventView.h"
#import "DDDateView.h"

@interface DDHomeViewController ()

@end

@implementation DDHomeViewController


#pragma mark - Fonctions de base

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //On set le background de la vue
    [[self view] setBackgroundColor:COULEUR_BACKGROUND];
    
    //On configure le pageControl
    [self.pageControlPlayer setTintColor:COULEUR_BLACK];
    
    //On set le pageControl à la vue
    [self.viewPlayer setPageControl:self.pageControlPlayer];
    [self.pageControlPlayer addTarget:self.viewPlayer action:@selector(changePlayerInPageControl:) forControlEvents:UIControlEventValueChanged];
    
    //On met en place la notification pour modifier le joueur
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateComponent)
                                                 name:UPDATE_PLAYER
                                               object:nil];

    //On met en place la notification pour mettre à jour le theme
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTheme)
                                                 name:UPDATE_THEME
                                               object:nil];
    //On met à jour les composants et le theme
    [self updateComponent];
    [self updateTheme];
}

- (void)viewWillAppear:(BOOL)animated
{
    //On recharge la scrollView
    [self.viewPlayer refreshPageControlWithScrollView:self.viewPlayer.scrollViewPlayer];
}

- (void)viewDidAppear:(BOOL)animated
{
    //On se dirige vers le bon jour
    [self.viewEvent updatePositionOfSelectedDay];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //On récupère la référence du controller contenu dans eventView
    [self.viewEvent setEventInfosViewController:segue.destinationViewController];
    [self.viewEvent.eventInfosViewController setDelegate:self.viewEvent];
}


#pragma mark - Controller function

//On met à jour les composants
- (void)updateComponent
{
    //On met à jour la vue de joueur et des évènements
    [self.viewPlayer updateComponent];
    [self.viewEvent updateComponent];
}

//Fonction pour mettre le theme à jour
- (void)updateTheme
{
    self.pageControlPlayer.numberOfPages = 1;
    self.pageControlPlayer.currentPage = 0;
    [self.viewDate updateTheme];
    [self.viewEvent updateTheme];
    [self.pageControlPlayer setCurrentPageIndicatorTintColor:[DDHelperController getMainTheme]];
}

@end
