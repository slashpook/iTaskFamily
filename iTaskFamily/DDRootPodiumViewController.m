//
//  DDRootPodiumViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 09/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDRootPodiumViewController.h"
#import "DDPodiumViewController.h"
#import "DDHistogramView.h"

@interface DDRootPodiumViewController ()

@end

@implementation DDRootPodiumViewController

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
    [self.scrollViewPodium setContentSize:CGSizeMake(self.scrollViewPodium.frame.size.width * 3, self.scrollViewPodium.frame.size.height)];
    [self.scrollViewPodium setShowsHorizontalScrollIndicator:NO];
    [self.scrollViewPodium setShowsVerticalScrollIndicator:NO];
    [self.scrollViewPodium setScrollsToTop:NO];
    [self.scrollViewPodium setPagingEnabled:YES];

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
    
    //On configure le pageControl
    [self.pageControlPodium setTintColor:COULEUR_BLACK];

    [self.pageControlPodium setNumberOfPages:3];
    [self.pageControlPodium setCurrentPage:0];
    
    //Initialisation des podiums et configuration
    _podiumSemaineEnCours = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"PodiumViewController"];
    [self.podiumSemaineEnCours setColorProgressView:COULEUR_CHAMBRE];
    
    _podiumSemainePrecedente = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"PodiumViewController"];
    [self.podiumSemainePrecedente setColorProgressView:COULEUR_HOME];
    
    _podiumTotalTrophees = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"PodiumViewController"];
    [self.podiumTotalTrophees setColorProgressView:COULEUR_PLAYER];
    
    //Initialisation du tableau de controllers
    _arrayPodiums = [[NSArray alloc] initWithObjects:self.podiumSemaineEnCours, self.podiumSemainePrecedente, self.podiumTotalTrophees, nil];
    
    //On charge les trois podiums
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    [self loadScrollViewWithPage:2];
    
    //On met en place la notification pour mettre à jour les podiums quand un joueurs est modifié
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateCurrentPodium)
                                                 name:UPDATE_PLAYER
                                               object:nil];
    
    //On met en place la notification pour mettre à jour le theme
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTheme)
                                                 name:UPDATE_THEME
                                               object:nil];

    //On met à jour le thème
    [self updateTheme];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //On met à jour les podiums
    [self updateDisplayOfComponent];
}


#pragma mark - Controller fonctions

//Fonction pour mettre le theme à jour
- (void)updateTheme
{
    [[self imageViewSelection] setBackgroundColor:[DDHelperController getMainTheme]];
    [self.pageControlPodium setCurrentPageIndicatorTintColor:[DDHelperController getMainTheme]];
}

//On met à jour les podiums
- (void)updateDisplayOfComponent
{
    for (int i = 0; i<3; i++)
    {
        DDPodiumViewController *podiumViewController = (DDPodiumViewController *)[self.arrayPodiums objectAtIndex:i];
        
        //Si on est sur une nouvelle page
        if (i == self.pageControlPodium.currentPage && podiumViewController.viewPremier.frame.size.height == 0)
            [podiumViewController updateComponentsAndDisplayProgressBar:YES forTypeOfPodium:i];
        else if (i != self.pageControlPodium.currentPage)
            [podiumViewController updateComponentsAndDisplayProgressBar:NO forTypeOfPodium:i];
    }
}

//On met à jour le podium courrant
- (void)updateCurrentPodium
{
    DDPodiumViewController *podiumViewController = (DDPodiumViewController *)[self.arrayPodiums objectAtIndex:self.pageControlPodium.currentPage];
    [podiumViewController updateComponentsAndDisplayProgressBar:YES forTypeOfPodium:self.pageControlPodium.currentPage];
}

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
    
    //On rafraichi la scrollView
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
    //On met à jour les podiums
    [self updateDisplayOfComponent];
    
    CGRect frame = self.scrollViewPodium.frame;
    frame.origin.x = frame.size.width * self.pageControlPodium.currentPage;
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollViewPodium setContentOffset:CGPointMake(frame.origin.x, 0)];
    }];
}


#pragma mark - Fonctions de gestion de l'UIPageControl et UIScrollView

//Fonction pour charger les vues dans la scrollview
- (void)loadScrollViewWithPage:(int)page
{
    //On teste si on peut afficher la vue (est ce qu'on est sur une page qui existe ou non)
    if (page < 0) return;
    if (page >= [self.arrayPodiums count]) return;
    
    //On rajoute le controller
    if (nil == [[[self.arrayPodiums objectAtIndex:page] view] superview])
    {
        //On crée un CGrect que l'on donnera à notre controller pour bien le positionner
        CGRect frame = self.scrollViewPodium.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        [[(DDPodiumViewController *)[self.arrayPodiums objectAtIndex:page] view] setFrame:frame];
        
        if (page == 0)
            [[(DDPodiumViewController *)[self.arrayPodiums objectAtIndex:page] buttonAddReward] setHidden:NO];
        else
            [[(DDPodiumViewController *)[self.arrayPodiums objectAtIndex:page] buttonAddReward] setHidden:YES];
        
        //On ajoute notre image à la scrollview
        [self.scrollViewPodium addSubview:[[self.arrayPodiums objectAtIndex:page] view]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (self.scrollViewPodium.contentOffset.x >= 0 && self.scrollViewPodium.contentOffset.x < 864)
    {
        self.pageControlPodium.currentPage = 0;
        [self.imageViewSelection setFrame:CGRectMake(self.scrollViewPodium.contentOffset.x/3, 0, 288, 50)];
    }
    else if (self.scrollViewPodium.contentOffset.x >= 864 && self.scrollViewPodium.contentOffset.x < 1728)
    {
        self.pageControlPodium.currentPage = 1;
        [self.imageViewSelection setFrame:CGRectMake(288 + ((self.scrollViewPodium.contentOffset.x - 864)/3), 0, 288, 50)];
    }
    else if (self.scrollViewPodium.contentOffset.x >= 1728 && self.scrollViewPodium.contentOffset.x <= 2592)
    {
        self.pageControlPodium.currentPage = 2;
        [self.imageViewSelection setFrame:CGRectMake(576, 0, 288, 50)];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.pageControlPodium.currentPage == 0)
        [self onPushButtonMenu:self.buttonScoreSemaineEnCours];
    else if (self.pageControlPodium.currentPage == 1)
        [self onPushButtonMenu:self.buttonScoreSemainePrecedente];
    else
        [self onPushButtonMenu:self.buttonNombreTotalTrophees];
}

@end
