//
//  DDCustomCategoryListCell.h
//  iTaskFamily
//
//  Created by Damien DELES on 06/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCustomCategoryListCell : UITableViewCell


#pragma mark - Variables

//ImageView de la couleur de la catégorie
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCategoryColor;

//Label de la catégorie
@property (weak, nonatomic) IBOutlet UILabel *labelNameCategory;

@end
