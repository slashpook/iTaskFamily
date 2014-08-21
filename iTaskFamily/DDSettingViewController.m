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

@interface DDSettingViewController ()

@end

@implementation DDSettingViewController

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
    
    //On initialise le popOver, le navigation controller et le playerManagerViewController
    _popOverViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"PopOverViewController"];
    _customColorViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"CustomColorViewController"];
    [self.customColorViewController setDelegate:self];

    //On met à jour les couleurs de la vue
    [self updateTheme];
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
    //On configure la couleur de teinte des switchs
    [self.switchMeteo setOnTintColor:[DDHelperController getMainTheme]];
}

//Fonction pour réinitialiser les taches
- (IBAction)onPushButtonResetTask:(id)sender
{
    
}

//Fonction pour changer la ville par défaut de la météo
- (IBAction)onPushButtonChangeVille:(id)sender
{
    
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

@end
