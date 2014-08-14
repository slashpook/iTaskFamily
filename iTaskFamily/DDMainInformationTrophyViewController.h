//
//  DDMainInformationTrophyViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 14/08/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDCustomProgressBar;

@interface DDMainInformationTrophyViewController : UIViewController


#pragma mark - Variables

//ImageView du nom de la catégory
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCategory;

//Label du nom de catégory
@property (weak, nonatomic) IBOutlet UILabel *labelLibelleCategory;

//Label titre du nombre de trophés gagnés
@property (weak, nonatomic) IBOutlet UILabel *labelTrophyTitle;

//Label description du nombre de trophés gagnés
@property (weak, nonatomic) IBOutlet UILabel *labelTrophyDesc;

//Label titre du nombre de points gagnés
@property (weak, nonatomic) IBOutlet UILabel *labelPointTitle;

//Label description du nombre de points gagnés
@property (weak, nonatomic) IBOutlet UILabel *labelPointDesc;

//Label titre du nombre d'events gagnés
@property (weak, nonatomic) IBOutlet UILabel *labelEventTitle;

//Label description du nombre d'events gagnés
@property (weak, nonatomic) IBOutlet UILabel *labelEventDesc;

//Categorie récupérée
@property (strong, nonatomic) CategoryTask *category;

//ProgressBar de bronze
@property (weak, nonatomic) IBOutlet DDCustomProgressBar *progressBarBronze;

//Label de réalisation du trophée de bronze
@property (weak, nonatomic) IBOutlet UILabel *labelRealizedBronze;

//Label du nombre total d'occurence à faire pour débloquer le trophée de bronze
@property (weak, nonatomic) IBOutlet UILabel *labelTotalBronze;

//ProgressBar d'argent
@property (weak, nonatomic) IBOutlet DDCustomProgressBar *progressBarArgent;

//Label de réalisation du trophée d'argent
@property (weak, nonatomic) IBOutlet UILabel *labelRealizedArgent;

//Label du nombre total d'occurence à faire pour débloquer le trophée d'argent
@property (weak, nonatomic) IBOutlet UILabel *labelTotalArgent;

//ProgressBar d'or
@property (weak, nonatomic) IBOutlet DDCustomProgressBar *progressBarOr;

//Label de réalisation du trophée d'or
@property (weak, nonatomic) IBOutlet UILabel *labelRealizedOr;

//Label du nombre total d'occurence à faire pour débloquer le trophée d'or
@property (weak, nonatomic) IBOutlet UILabel *labelTotalOr;

#pragma mark - Fonctions

//On met à jour la vue
- (void)updateComponent;

@end
