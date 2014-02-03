//
//  DDSettingViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 03/02/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDSettingViewController.h"

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
    
    //On set le background de la vue
    [[self view] setBackgroundColor:COULEUR_BACKGROUND];
    
    //On configure les radius des vues
    [self.viewProtection.layer setCornerRadius:10.0];
    [self.viewProtection.layer setMasksToBounds:YES];
    [self.viewTask.layer setCornerRadius:10.0];
    [self.viewTask.layer setMasksToBounds:YES];
    [self.viewMeteo.layer setCornerRadius:10.0];
    [self.viewMeteo.layer setMasksToBounds:YES];
    
    //On met la couleur de background des view header et background
    [self.imageViewHeaderProtection setBackgroundColor:COULEUR_BLACK];
    [self.imageViewHeaderTask setBackgroundColor:COULEUR_BLACK];
    [self.imageViewHeaderMeteo setBackgroundColor:COULEUR_BLACK];
    
    //On set la police et la couleur des labels et boutons
    [self.labelTitreProtection setFont:POLICE_HEADER];
    [self.labelTitreProtection setTextColor:COULEUR_WHITE];
    [self.labelTitreTask setFont:POLICE_HEADER];
    [self.labelTitreTask setTextColor:COULEUR_WHITE];
    [[self.buttonResetTask titleLabel] setTextColor:COULEUR_WHITE];
    [self.labelTitreMeteo setFont:POLICE_HEADER];
    [self.labelTitreMeteo setTextColor:COULEUR_WHITE];
    [[self.buttonChangeVille titleLabel] setTextColor:COULEUR_WHITE];
    
    //On configure la couleur de teinte des switch
    [self.switchPassword setOnTintColor:COULEUR_SETTING];
    [self.switchMeteo setOnTintColor:COULEUR_SETTING];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Fonctions du controller

//Fonction pour réinitialiser les taches
- (IBAction)onPushButtonResetTask:(id)sender
{
    
}

//Fonction pour changer la ville par défaut de la météo
- (IBAction)onPushButtonChangeVille:(id)sender
{
    
}

@end
