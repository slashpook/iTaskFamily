//
//  DDSettingViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 03/02/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDSettingViewController.h"
#import "DDCustomButton.h"
#import "DDPopOverViewController.h"
#import "DDSettingTableViewCell.h"

@interface DDSettingViewController ()

@end

@implementation DDSettingViewController


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
    
    //On met en place la notification pour mettre à jour le theme
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTheme)
                                                 name:UPDATE_THEME
                                               object:nil];
    
    //On set le background de la vue
    [[self view] setBackgroundColor:COULEUR_BACKGROUND];
    
    //On configure les radius des vues
    [self.viewRecompense.layer setCornerRadius:10.0];
    [self.viewRecompense.layer setMasksToBounds:YES];
    [self.viewTask.layer setCornerRadius:10.0];
    [self.viewTask.layer setMasksToBounds:YES];
    [self.viewMeteo.layer setCornerRadius:10.0];
    [self.viewMeteo.layer setMasksToBounds:YES];
    [self.viewTheme.layer setCornerRadius:10.0];
    [self.viewTheme.layer setMasksToBounds:YES];
    [self.viewTutoriel.layer setCornerRadius:10.0];
    [self.viewTutoriel.layer setMasksToBounds:YES];
    [self.viewAchat.layer setCornerRadius:10.0];
    [self.viewAchat.layer setMasksToBounds:YES];
    [self.viewCurrentColor.layer setCornerRadius:5.0];
    [self.buttonColor1.layer setCornerRadius:5.0];
    [self.buttonColor2.layer setCornerRadius:5.0];
    [self.buttonColor3.layer setCornerRadius:5.0];
    [self.buttonColor4.layer setCornerRadius:5.0];
    [self.buttonColor5.layer setCornerRadius:5.0];
    [self.buttonColor6.layer setCornerRadius:5.0];
    [self.buttonColor7.layer setCornerRadius:5.0];
    [self.buttonColor8.layer setCornerRadius:5.0];
    [self.buttonColor9.layer setCornerRadius:5.0];
    [self.buttonColor10.layer setCornerRadius:5.0];
    [self.buttonColor11.layer setCornerRadius:5.0];
    [self.buttonColor12.layer setCornerRadius:5.0];
    
    //On met la couleur de background des view header et background
    [self.imageViewHeaderRecompense setBackgroundColor:COULEUR_BLACK];
    [self.imageViewHeaderTask setBackgroundColor:COULEUR_BLACK];
    [self.imageViewHeaderMeteo setBackgroundColor:COULEUR_BLACK];
    [self.imageViewHeaderTheme setBackgroundColor:COULEUR_BLACK];
    [self.imageViewHeaderTutoriel setBackgroundColor:COULEUR_BLACK];
    [self.imageViewHeaderAchat setBackgroundColor:COULEUR_BLACK];
    
    //On set la police et la couleur des labels et boutons
    [self.labelTitreRecompense setFont:POLICE_HEADER];
    [self.labelTitreRecompense setTextColor:COULEUR_WHITE];
    [self.labelInfoRecompense setFont:POLICE_SETTING_CONTENT];
    [self.labelInfoRecompense setTextColor:COULEUR_BLACK];
    [self.labelTitreTask setFont:POLICE_HEADER];
    [self.labelTitreTask setTextColor:COULEUR_WHITE];
    [self.labelInfoTask setFont:POLICE_SETTING_CONTENT];
    [self.labelInfoTask setTextColor:COULEUR_BLACK];
    [[self.buttonResetTask titleLabel] setTextColor:COULEUR_WHITE];
    [self.labelTitreMeteo setFont:POLICE_HEADER];
    [self.labelTitreMeteo setTextColor:COULEUR_WHITE];
    [self.labelInfoMeteo setFont:POLICE_SETTING_CONTENT];
    [self.labelInfoMeteo setTextColor:COULEUR_BLACK];
    [[self.buttonChangeVille titleLabel] setTextColor:COULEUR_WHITE];
    [self.labelTitreTheme setFont:POLICE_HEADER];
    [self.labelTitreTheme setTextColor:COULEUR_WHITE];
    [[self.buttonColorPerso titleLabel] setTextColor:COULEUR_WHITE];
    [self.labelTitreTutoriel setFont:POLICE_HEADER];
    [self.labelTitreTutoriel setTextColor:COULEUR_WHITE];
    [self.labelTitreAchat setFont:POLICE_HEADER];
    [self.labelTitreAchat setTextColor:COULEUR_WHITE];
    
    //On set le delegate de la tableView
    [self.tableViewTutorial setDelegate:self];
    [self.tableViewTutorial setDataSource:self];
    
    //On initialise le popOver, le navigation controller et le playerManagerViewController
    _popOverViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"PopOverViewController"];
    _awardViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"AwardViewController"];
    [self.awardViewController setDelegate:self];
    _meteoViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"MeteoViewController"];
    [self.meteoViewController setDelegate:self];
    _customColorViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"CustomColorViewController"];
    [self.customColorViewController setDelegate:self];
    _tutorialViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"TutorialViewController"];
    [self.tutorialViewController setDelegate:self];

    //On met à jour les couleurs de la vue
    [self updateTheme];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //On set le switch
    [self.switchMeteo setOn:[[DDManagerSingleton instance] isGeolocalisationActivate]];
}


#pragma mark - Fonctions du controller

//Fonction pour mettre le theme à jour
- (void)updateTheme
{
    [self.viewCurrentColor setBackgroundColor:[DDHelperController getMainTheme]];
    [self.buttonConfigureRecompense setColorTitleEnable:[DDHelperController getMainTheme]];
    [self.buttonConfigureRecompense setNeedsDisplay];
    [self.buttonResetTask setColorTitleEnable:[DDHelperController getMainTheme]];
    [self.buttonResetTask setNeedsDisplay];
    [self.buttonChangeVille setColorTitleEnable:[DDHelperController getMainTheme]];
    [self.buttonChangeVille setNeedsDisplay];
    [self.buttonColorPerso setColorTitleEnable:[DDHelperController getMainTheme]];
    [self.buttonColorPerso setNeedsDisplay];
    [self.buttonAchatInApp setColorTitleEnable:[DDHelperController getMainTheme]];
    [self.buttonAchatInApp setNeedsDisplay];
    [self.buttonRestaureAchatInApp setColorTitleEnable:[DDHelperController getMainTheme]];
    [self.buttonRestaureAchatInApp setNeedsDisplay];
    
    //On configure la couleur de teinte des switchs
    [self.switchMeteo setOnTintColor:[DDHelperController getMainTheme]];
}

//Fonction pour ajouter une récompense
- (IBAction)onPushAddAward:(id)sender
{
    [[[[[[UIApplication sharedApplication] delegate] window] rootViewController] view] addSubview:self.popOverViewController.view];
    
    //On présente la popUp
    CGRect frame = self.awardViewController.view.frame;
    [self.popOverViewController presentPopOverWithContentView:self.awardViewController.view andSize:frame.size andOffset:CGPointMake(0, 0)];
}

//Fonction pour réinitialiser les taches
- (IBAction)onPushButtonResetTask:(id)sender
{
    [DDCustomAlertView displayAnswerMessage:NSLocalizedString(@"RESET_TACHE", nil) withDelegate:self];
}

//On appuie sur le switch de la météo
- (IBAction)onPushSwitchMeteo:(id)sender
{
    [[DDManagerSingleton instance] setIsGeolocationActivate:self.switchMeteo.isOn];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_METEO object:nil];
}

//Fonction pour changer la ville par défaut de la météo
- (IBAction)onPushButtonChangeVille:(id)sender
{
    [[[[[[UIApplication sharedApplication] delegate] window] rootViewController] view] addSubview:self.popOverViewController.view];
    
    //On présente la popUp
    CGRect frame = self.meteoViewController.view.frame;
    [self.popOverViewController presentPopOverWithContentView:self.meteoViewController.view andSize:frame.size andOffset:CGPointMake(0, 0)];
}

//Fonction pour changer la couleur de l'appli
- (IBAction)onPushButtonColor:(id)sender
{
    [DDHelperController saveThemeWithColor:[sender backgroundColor]];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_THEME object:nil];
}

//Fonction pour ouvrir une popup et choisir une couleur personalisé
- (IBAction)onPushButtonChoiceColorPerso:(id)sender
{
    [[[[[[UIApplication sharedApplication] delegate] window] rootViewController] view] addSubview:self.popOverViewController.view];
    
    //On présente la popUp
    CGRect frame = self.customColorViewController.view.frame;
    [self.popOverViewController presentPopOverWithContentView:self.customColorViewController.view andSize:frame.size andOffset:CGPointMake(0, 0)];
}


#pragma mark - CustomColorView delegate functions

- (void)closeCustomColorView
{
    //On enlève la popUp
    [self.popOverViewController hide];
}


#pragma mark - DDAwardViewProtocol fonctions

//Fonction pour fermer la popUp
- (void)closeAwardView
{
    //On enlève la popUp
    [self.popOverViewController hide];
}


#pragma mark - DDMeteoViewProtocol fonctions

//Fonction pour fermer la popUp
- (void)closeMeteoView
{
    //On enlève la popUp
    [self.popOverViewController hide];
}


#pragma mark - DDTutorialViewControllerProtocol fonctions

//Fonction pour fermer la popUp
- (void)closeTutorialView
{
    //On enlève la popUp
    [self.popOverViewController hide];
}


#pragma mark - TableView Delegate fonctions

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableViewTutorial cellForRowAtIndexPath:indexPath];
    [cell setBackgroundColor:COULEUR_CELL_SELECTED];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableViewTutorial cellForRowAtIndexPath:indexPath];
    [cell setBackgroundColor:COULEUR_WHITE];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //On récupère la cellule
    DDSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell" forIndexPath:indexPath];
    
    NSString *titleTuto = [NSString stringWithFormat:@"TUTO%i", (int)indexPath.row];
    [cell.labelTutorial setText:NSLocalizedString(titleTuto, nil)];
    [cell.labelTutorial setBackgroundColor:COULEUR_TRANSPARENT];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[[[[[UIApplication sharedApplication] delegate] window] rootViewController] view] addSubview:self.popOverViewController.view];
    
    [self.tutorialViewController setTutorialChapter:(int)indexPath.row];
    
    //On présente la popUp
    CGRect frame = [[UIScreen mainScreen] bounds];
    [self.popOverViewController presentPopOverWithContentView:self.tutorialViewController.view andSize:frame.size andOffset:CGPointMake(0, 0)];

}


#pragma mark - UIAlertViewProtocol delegate functions

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //On annule pas l'event
    if (buttonIndex == 0)
    {
        [[DDDatabaseAccess instance] resetTasks];
        [DDCustomAlertView displayInfoMessage:NSLocalizedString(@"RESET_TACHE_FINI", nil)];
    }
}

@end
