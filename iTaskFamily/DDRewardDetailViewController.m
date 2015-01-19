//
//  DDRewardDetailViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 21/08/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDRewardDetailViewController.h"

@interface DDRewardDetailViewController ()

@end

@implementation DDRewardDetailViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:COULEUR_BACKGROUND];
    
    //On cache la navigation bar
    [self.navigationController setNavigationBarHidden:YES];
    
    //On configure l'arrondi des vues et composants
    [self.view.layer setCornerRadius:10.0];
    [self.view.layer setMasksToBounds:YES];
    
    //On set la police et la couleur des label et textfield
    [self.labelReward setTextColor:COULEUR_BLACK];
    [self.labelReward setFont:POLICE_PLAYER_REWARD];
    
    //On met en place la barre de navigation
    _custoNavBar = [[DDCustomNavigationBarController alloc] initWithDelegate:self andTitle:@"" andBackgroundColor:[DDHelperController getMainTheme] andImage:[UIImage imageNamed:@"RewardDetailButtonAdd"]];
    [[self.custoNavBar view] setFrame:CGRectMake(0, 0, 380, 50)];
    [[self.custoNavBar buttonRight] setTitle:NSLocalizedString(@"FERMER", nil) forState:UIControlStateNormal];
    [self.view addSubview:self.custoNavBar.view];
    
    
    //On met en place la notification pour mettre à jour le theme
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTheme)
                                                 name:UPDATE_THEME
                                               object:nil];
    
    //On met à jour les composants
    [self updateTheme];

}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateComponent];
}


#pragma mark - Fonctions du controller

//On met à jour les composants
- (void)updateComponent
{
    [self.labelReward setText:self.reward.libelle];
}

//On met à jour le theme
- (void)updateTheme
{
    [self.custoNavBar.view setBackgroundColor:[DDHelperController getMainTheme]];
}


#pragma mark - NavigationBar fonctions

//On appuie sur le bouton de gauche
- (void)onPushRightBarButton
{
    //On ferme la vue
    [self.delegate closeRewardDetailView];
}



@end
