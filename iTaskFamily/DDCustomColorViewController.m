//
//  DDCustomColorViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 21/08/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDCustomColorViewController.h"
#import "NKOColorPickerView.h"

@interface DDCustomColorViewController ()

@end

@implementation DDCustomColorViewController

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

    [self.view setBackgroundColor:COULEUR_BACKGROUND];
    
    //On configure l'arrondi des vues
    [self.view.layer setCornerRadius:10.0];
    [self.view.layer setMasksToBounds:YES];
    
    //On met en place la barre de navigation
    _custoNavBar = [[DDCustomNavigationBarController alloc] initWithDelegate:self andTitle:@"" andBackgroundColor:[DDHelperController getMainTheme] andImage:[UIImage imageNamed:@"CustomColorChoice"]];
    [[self.custoNavBar view] setFrame:CGRectMake(0, 0, 380, 50)];
    [[self.custoNavBar buttonRight] setTitle:NSLocalizedString(@"SAUVER", nil) forState:UIControlStateNormal];
    [[self.custoNavBar buttonLeft] setTitle:NSLocalizedString(@"ANNULER", nil) forState:UIControlStateNormal];
    [self.view addSubview:self.custoNavBar.view];
    
    //On met en place la notification pour mettre à jour le theme
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTheme)
                                                 name:UPDATE_THEME
                                               object:nil];
}


#pragma mark - Fonctions du controller

//On met à jour le theme
- (void)updateTheme
{
    [self.custoNavBar.view setBackgroundColor:[DDHelperController getMainTheme]];
}


#pragma mark - NavigationBar fonctions

//On appuie sur le bouton de gauche
- (void)onPushLeftBarButton
{
    //On ferme la vue
    [self.delegate closeCustomColorView];
}

//On appuie sue le bouton de droite
- (void)onPushRightBarButton
{
    //On met à jour la couleur du thème
    [DDHelperController saveThemeWithColor:self.colorPickerView.color];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_THEME object:nil];
    
    //On ferme la vue
    [self.delegate closeCustomColorView];
}

@end
