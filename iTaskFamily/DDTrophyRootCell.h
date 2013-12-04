//
//  DDTrophyRootCell.h
//  iTaskFamily
//
//  Created by Damien DELES on 02/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDTrophyRootCell : UITableViewCell


#pragma mark - Variables

//Label qui affiche le nombre de trophées pour une catégorie donnée
@property (weak, nonatomic) IBOutlet UILabel *labelNumberTrophyCategory;

//Vue de la couleur de la catégorie
@property (weak, nonatomic) IBOutlet UIView *viewCouleurCategory;

//Label du nom de la catégorie
@property (weak, nonatomic) IBOutlet UILabel *labelName;

//Vue du background des trophées
@property (weak, nonatomic) IBOutlet UIView *viewBackgroundTrophies;

@end
