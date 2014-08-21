//
//  DDAwardViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 03/02/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDAwardViewController.h"

@interface DDAwardViewController ()

@end

@implementation DDAwardViewController

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
    
    //On set la police et la couleur des label et textfield
    [[self labelPremier] setFont:POLICE_AWARD_TITLE];
    [[self labelPremier] setTextColor:COULEUR_BLACK];
    [self.textFieldPremier setFont:POLICE_AWARD_CONTENT];
    [self.textFieldPremier setTextColor:COULEUR_BLACK];
    [[self labelSecond] setFont:POLICE_AWARD_TITLE];
    [[self labelSecond] setTextColor:COULEUR_BLACK];
    [self.textFieldSecond setFont:POLICE_AWARD_CONTENT];
    [self.textFieldSecond setTextColor:COULEUR_BLACK];
    [[self labelTroisieme] setFont:POLICE_AWARD_TITLE];
    [[self labelTroisieme] setTextColor:COULEUR_BLACK];
    [self.textFieldTroisieme setFont:POLICE_AWARD_CONTENT];
    [self.textFieldTroisieme setTextColor:COULEUR_BLACK];
    
    //On rajoute un padding sur les textfield
    UIView *paddingViewPremier = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.textFieldPremier.leftView = paddingViewPremier;
    self.textFieldPremier.leftViewMode = UITextFieldViewModeAlways;
    [self.textFieldPremier.layer setCornerRadius:5.0];
    [self.textFieldPremier.layer setMasksToBounds:YES];
    [self.textFieldPremier setDelegate:self];
    UIView *paddingViewSecond = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.textFieldSecond.leftView = paddingViewSecond;
    self.textFieldSecond.leftViewMode = UITextFieldViewModeAlways;
    [self.textFieldSecond.layer setCornerRadius:5.0];
    [self.textFieldSecond.layer setMasksToBounds:YES];
    [self.textFieldSecond setDelegate:self];
    UIView *paddingViewTroisieme = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.textFieldTroisieme.leftView = paddingViewTroisieme;
    self.textFieldTroisieme.leftViewMode = UITextFieldViewModeAlways;
    [self.textFieldTroisieme.layer setCornerRadius:5.0];
    [self.textFieldTroisieme.layer setMasksToBounds:YES];
    [self.textFieldTroisieme setDelegate:self];
    
    //On cache la navigation bar
    [self.navigationController setNavigationBarHidden:YES];
    
    //On configure l'arrondi des vues
    [self.navigationController.view.layer setCornerRadius:10.0];
    [self.navigationController.view.layer setMasksToBounds:YES];
    
    //On met en place la barre de navigation
    _custoNavBar = [[DDCustomNavigationBarController alloc] initWithDelegate:self andTitle:@"" andBackgroundColor:[DDHelperController getMainTheme] andImage:[UIImage imageNamed:@"AwardAddButtonNavBar"]];
    [[self.custoNavBar view] setFrame:CGRectMake(0, 0, 380, 50)];
    [[self.custoNavBar buttonRight] setTitle:@"Sauver" forState:UIControlStateNormal];
    [[self.custoNavBar buttonLeft] setTitle:@"Annuler" forState:UIControlStateNormal];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Fonctions du controller

//On sauvegarde les récompenses
- (void)saveAward
{

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
    [self.delegate closeAwardView];
}

//On appuie sue le bouton de droite
- (void)onPushRightBarButton
{
    //On ferme la vue
    [self.delegate closeAwardView];
}

@end
