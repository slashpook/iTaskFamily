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
{
    NSArray *arrayReward;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        arrayReward = [[NSArray alloc] initWithArray: [[DDDatabaseAccess instance] getRewardSortedForWeekAndYear:[DDHelperController getWeekAndYearForDate:[NSDate date]]]];
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

- (void)viewWillAppear:(BOOL)animated
{
    [self updateComponent];
}

#pragma mark - Fonctions du controller

- (void)updateComponent
{
    if ([arrayReward objectAtIndex:0] != [NSNull null])
        [self.textFieldPremier setText:[[arrayReward objectAtIndex:0] libelle]];
    
    if ([arrayReward objectAtIndex:1] != [NSNull null])
        [self.textFieldSecond setText:[[arrayReward objectAtIndex:1] libelle]];

    if ([arrayReward objectAtIndex:2] != [NSNull null])
        [self.textFieldTroisieme setText:[[arrayReward objectAtIndex:2] libelle]];
}

//On met le thème à jour
- (void)updateTheme
{
    [self.custoNavBar.view setBackgroundColor:[DDHelperController getMainTheme]];
}

//On crée les récompenses
- (void)saveRewardsWithLibelle:(NSString *)libelle andType:(NSString *)type
{
    Reward *reward = [NSEntityDescription insertNewObjectForEntityForName:@"Reward"
                                                             inManagedObjectContext:[[DDDatabaseAccess instance] dataBaseManager].managedObjectContext];
    [reward setWeekAndYear:[DDHelperController getWeekAndYearForDate:[NSDate date]]];
    [reward setLibelle:libelle];
    [reward setType:type];
    
    [[DDDatabaseAccess instance] createReward:reward];
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
    //On supprime toute les récompenses au préalable
    for (id reward in arrayReward)
    {
        if (reward != [NSNull null])
            [[DDDatabaseAccess instance] deleteReward:reward];
    }
    
    if ([[self.textFieldPremier text] length] > 0)
        [self saveRewardsWithLibelle:self.textFieldPremier.text andType:@"Or"];
    
    if ([[self.textFieldSecond text] length] > 0)
        [self saveRewardsWithLibelle:self.textFieldSecond.text andType:@"Argent"];
    
    if ([[self.textFieldTroisieme text] length] > 0)
        [self saveRewardsWithLibelle:self.textFieldTroisieme.text andType:@"Bronze"];
    
    //On ferme la vue
    [self.delegate closeAwardView];
}

@end
