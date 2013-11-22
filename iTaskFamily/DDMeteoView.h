//
//  DDMeteoView.h
//  iTaskFamily
//
//  Created by Damien DELES on 22/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDMeteoView : UIView


#pragma mark - Variables

//Image du haut de la vue
@property (weak, nonatomic)IBOutlet UIImageView *imageViewHeader;

//Label du jour de la semaine
@property (weak, nonatomic)IBOutlet UILabel *labelMeteo;

#pragma mark - Fonctions


@end
