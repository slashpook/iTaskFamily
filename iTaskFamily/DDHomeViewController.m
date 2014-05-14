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
#import "DDCustomNotification.h"

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
    if ([self.pageControlPlayer respondsToSelector:@selector(setTintColor:)])
    {
        [self.pageControlPlayer setTintColor:COULEUR_BLACK];
        [self.pageControlPlayer setCurrentPageIndicatorTintColor:COULEUR_HOME];
    }
    
    //On set le pageControl à la vue
    [self.viewPlayer setPageControl:self.pageControlPlayer];
    [self.pageControlPlayer addTarget:self.viewPlayer action:@selector(changePlayerInPageControl:) forControlEvents:UIControlEventValueChanged];
    
    //On met en place la notification pour modifier le joueur
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateComponent)
                                                 name:UPDATE_PLAYER
                                               object:nil];
    //On met en place la notification pour mettre à jour les pastilles de notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateNotifications)
                                                 name:UPDATE_NOTIFICATION
                                               object:nil];
    
    //On initialise le tableau des notifications
    _arrayWeekNotification = [[NSArray alloc] initWithObjects:self.viewNotificationLundi, self.viewNotificationMardi, self.viewNotificationMercredi, self.viewNotificationJeudi, self.viewNotificationVendredi, self.viewNotificationSamedi, self.viewNotificationDimanche, nil];
    //On cache les notifications
    for (DDCustomNotification *viewNotification in self.arrayWeekNotification)
        [viewNotification setHidden:YES];
    
    
    //On met à jour les composants
    [self updateComponent];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    //On cache les notifications
    for (DDCustomNotification *viewNotification in self.arrayWeekNotification) {
        if ([viewNotification isHidden] == NO)
            [viewNotification popOut];
    }
    
    //On met à jour les notifications après qu'on les ai préalablement cachées
    [self performSelector:@selector(updateNotifications) withObject:nil afterDelay:0.3];
}

//On met à jour les notifications
- (void)updateNotifications
{
    //On boucle sur le tableau de notif, on les caches ou non en fonction
    for (DDCustomNotification *viewNotification in self.arrayWeekNotification)
    {
        //On récupère l'index
        NSString *dayOfNotification = [NSString stringWithFormat:@"%i", (int)[self.arrayWeekNotification indexOfObject:viewNotification]];
        
        //On récupère le compteur
        int compteur = [[DDDatabaseAccess instance] getNumberOfEventUncheckedForPlayer:[[DDManagerSingleton instance] currentPlayer] forWeekAndYear:[DDHelperController getWeekAndYear] andDay:dayOfNotification];
                                
        //On met à jour le label du compteur d'évènement non terminé
        [[viewNotification labelNumberNotification] setText:[NSString stringWithFormat:@"%i", compteur]];
        
        //Si on a plus d'évènement, si ce n'est déjà fait, on cache la notif
        if (compteur == 0)
        {
            if ([viewNotification isHidden] == NO)
                [viewNotification popOut];
        }
        //Sinon si elle est caché, on la fait apparaitre
        else
        {
            if ([viewNotification isHidden] == YES)
                [viewNotification popIn];
        }
    }
}

@end
