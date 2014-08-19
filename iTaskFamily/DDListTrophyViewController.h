//
//  DDListTrophyViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 15/08/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDListTrophyViewController : UIViewController


#pragma mark - Variables

//ImageView du type de trophée
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTrophy;

//Nom du trophée
@property (weak, nonatomic) IBOutlet UILabel *labelLibelleTrophy;

//Nombre de trophées réalisés
@property (weak, nonatomic) IBOutlet UILabel *labelRealisationTrophy;

//TableView des trophées
@property (weak, nonatomic) IBOutlet UITableView *tableViewTrophy;

//Category sélectionné
@property (strong, nonatomic) CategoryTask *category;

//Le trophée à traiter
@property (strong, nonatomic) CategoryTrophy *trophy;


#pragma mark - Fonctions

//On met à jour la vue
- (void)updateComponent;

@end
