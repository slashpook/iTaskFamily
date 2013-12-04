//
//  DDCategoryMiniatureCollectionViewCell.h
//  iTaskFamily
//
//  Created by Damien DELES on 04/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCategoryMiniatureCollectionViewCell : UICollectionViewCell


#pragma mark - Variables

//ImageView de la catégorie
@property (strong, nonatomic) IBOutlet UIImageView *imageViewCategory;

//Label de la catégorie
@property (strong, nonatomic) IBOutlet UILabel *labelName;


@end
