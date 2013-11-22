//
//  DDPlayerView.h
//  iTaskFamily
//
//  Created by Damien DELES on 21/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDPlayerView : UIView


#pragma mark - Variables

//Fond flou du haut de la vue
@property (weak, nonatomic)IBOutlet UIImageView *imageViewHeader;

//Fond flou du bas de la vue
@property (weak, nonatomic)IBOutlet UIImageView *imageViewBottom;

//Image du joueur
@property (weak, nonatomic)IBOutlet UIImageView *imageViewPlayer;

//Label nom du joueur
@property (weak, nonatomic)IBOutlet UILabel *labelNamePlayer;

//Label des points du joueur
@property (weak, nonatomic)IBOutlet UILabel *labelPointPlayer;


#pragma mark - Fonctions


@end
