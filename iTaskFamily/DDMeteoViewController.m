//
//  DDMeteoViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 22/08/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDMeteoViewController.h"

@interface DDMeteoViewController ()

@end

@implementation DDMeteoViewController

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
    
    //On set la police et la couleur des label et textfield
    [[self labelChoiceCity] setFont:POLICE_METEO_SETTING_TITLE];
    [[self labelChoiceCity] setTextColor:COULEUR_BLACK];
    [self.textFieldChoiceCity setFont:POLICE_METEO_SETTING_CONTENT];
    [self.textFieldChoiceCity setTextColor:COULEUR_BLACK];
    [[self labelTitleActualCity] setFont:POLICE_METEO_SETTING_TITLE];
    [[self labelDescActualCity] setFont:POLICE_METEO_SETTING_CONTENT];
    [self.labelDescActualCity setTextColor:COULEUR_BLACK];
    
    //On rajoute un padding sur les textfield
    UIView *paddingViewPremier = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.textFieldChoiceCity.leftView = paddingViewPremier;
    self.textFieldChoiceCity.leftViewMode = UITextFieldViewModeAlways;
    [self.textFieldChoiceCity.layer setCornerRadius:5.0];
    [self.textFieldChoiceCity.layer setMasksToBounds:YES];
    [self.textFieldChoiceCity setDelegate:self];

    //On met en place la barre de navigation
    _custoNavBar = [[DDCustomNavigationBarController alloc] initWithDelegate:self andTitle:@"" andBackgroundColor:[DDHelperController getMainTheme] andImage:[UIImage imageNamed:@"MeteoChangeVille"]];
    [[self.custoNavBar view] setFrame:CGRectMake(0, 0, 380, 50)];
    [[self.custoNavBar buttonRight] setTitle:NSLocalizedString(@"SAUVER", nil) forState:UIControlStateNormal];
    [[self.custoNavBar buttonLeft] setTitle:NSLocalizedString(@"ANNULER", nil) forState:UIControlStateNormal];
    [self.view addSubview:self.custoNavBar.view];
    
    //On met en place la notification pour savoir quand le clavier est caché
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    //On met en place la notification pour mettre à jour le theme
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTheme)
                                                 name:UPDATE_THEME
                                               object:nil];
}


#pragma mark - Fonctions de base

//On met le thème à jour
- (void)updateTheme
{
    [self.custoNavBar.view setBackgroundColor:[DDHelperController getMainTheme]];
}


#pragma mark - UITextFieldDelegate fonctions

//Fonction appelé lorsque l'on commence l'édition d'un champs
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UP_POPOVER object:[NSNumber numberWithInteger:100]];
}

//Fonction appelé lorsqu'on l'on termine l'édition d'un champs
- (void)keyboardDidHide:(NSNotification *)notif
{
    //On redescend la vue
    [[NSNotificationCenter defaultCenter] postNotificationName:UP_POPOVER object:[NSNumber numberWithInteger:0]];
}


#pragma mark - NavigationBar fonctions

//On appuie sur le bouton de gauche
- (void)onPushLeftBarButton
{
    //On ferme la vue
    [self.delegate closeMeteoView];
}

//On appuie sue le bouton de droite
- (void)onPushRightBarButton
{
    if ([self.textFieldChoiceCity.text length] > 0)
       [[DDManagerSingleton instance] setMeteo:self.textFieldChoiceCity.text];
    
    //On met à jour la météo
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_METEO object:nil];
    
    //On ferme la vue
    [self.delegate closeMeteoView];
}



@end
