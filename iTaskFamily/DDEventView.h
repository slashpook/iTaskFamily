//
//  DDEventView.h
//  iTaskFamily
//
//  Created by Damien DELES on 24/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDEventView : UIView


#pragma mark - Variables

//Header de la vue
@property (weak, nonatomic)IBOutlet UIImageView *imageViewHeader;

//Image de sélection du jour
@property (weak, nonatomic)IBOutlet UIImageView *imageViewSelection;

//Boutton du Lundi
@property (retain, nonatomic) IBOutlet UIButton *buttonLundi;

//Boutton du Mardi
@property (retain, nonatomic) IBOutlet UIButton *buttonMardi;

//Boutton du Mercredi
@property (retain, nonatomic) IBOutlet UIButton *buttonMercredi;

//Boutton du Jeudi
@property (retain, nonatomic) IBOutlet UIButton *buttonJeudi;

//Boutton du Vendredi
@property (retain, nonatomic) IBOutlet UIButton *buttonVendredi;

//Boutton du Samedi
@property (retain, nonatomic) IBOutlet UIButton *buttonSamedi;

//Boutton du Dimanche
@property (retain, nonatomic) IBOutlet UIButton *buttonDimanche;


#pragma mark - Fonctions

//On appuie sur un des boutons
- (IBAction)onPushDayButton:(id)sender;


@end
