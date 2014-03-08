//
//  DDCustomEventCell.h
//  iTaskFamily
//
//  Created by Damien DELES on 02/03/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDCustomCheckbox;

@interface DDCustomEventCell : UITableViewCell


#pragma mark - Variables

//ImageView qui indique la couleur de la catégorie
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCategoryColor;

//Label du nom de la tache
@property (weak, nonatomic) IBOutlet UILabel *labelTask;

//ImageView de separation du nom de la tache avec les infos
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSeparation;

//Label d'infos de la tache
@property (weak, nonatomic) IBOutlet UILabel *labelInfo;

//Checkbox customisée
@property (weak, nonatomic) IBOutlet DDCustomCheckbox *customCheckbox;

@end
