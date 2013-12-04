//
//  DDCustomCategoryCell.h
//  iTaskFamily
//
//  Created by Damien DELES on 04/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCustomCategoryCell : UITableViewCell


#pragma mark - Variables

//Image de coté de la cellule
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;

//Label du nom de la tache
@property (weak, nonatomic) IBOutlet UILabel *labelNomTask;

//Label des points de la tache
@property (weak, nonatomic) IBOutlet UILabel *labelPoint;

@end
