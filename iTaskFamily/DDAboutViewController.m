//
//  DDAboutViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 17/09/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDAboutViewController.h"

@interface DDAboutViewController ()

@end

@implementation DDAboutViewController

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
	
    //On met la couleur de fond
    [self.view setBackgroundColor:COULEUR_BACKGROUND];
    
    //On configure l'arrondi des vues
    [self.view.layer setCornerRadius:10.0];
    [self.view.layer setMasksToBounds:YES];
    
    //On met en place la barre de navigation
    _custoNavBar = [[DDCustomNavigationBarController alloc] initWithDelegate:self andTitle:NSLocalizedString(@"APROPOS", nil) andBackgroundColor:[DDHelperController getMainTheme] andImage:[UIImage imageNamed:nil]];
    [[self.custoNavBar view] setFrame:CGRectMake(0, 0, 380, 50)];
    [[self.custoNavBar buttonLeft] setTitle:NSLocalizedString(@"FERMER", nil) forState:UIControlStateNormal];
    [self.view addSubview:self.custoNavBar.view];
    
    //On met en place la notification pour mettre à jour le theme
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTheme)
                                                 name:UPDATE_THEME
                                               object:nil];
    
    //On met la durée de slashpook inc constamment à jour
    int currentYear = [[DDHelperController getYearInLetter] intValue];
    if (currentYear > 2012)
        [self.labelCopyright setText:[NSString stringWithFormat:@"2012-%i Slashpook Inc", currentYear]];
    else
        [self.labelCopyright setText:@"2012 Slashpook Inc"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


#pragma mark - Fonctions du controller

//On met le thème à jour
- (void)updateTheme
{
    [self.custoNavBar.view setBackgroundColor:[DDHelperController getMainTheme]];
}


#pragma mark - NavigationBar fonctions

//On appuie sur le bouton de gauche
- (void)onPushLeftBarButton
{
    //On ferme la vue
    [self.delegate closeAboutView];
}

@end
