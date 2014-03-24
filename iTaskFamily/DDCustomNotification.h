//
//  DDCustomNotification.h
//  iTaskFamily
//
//  Created by Damien DELES on 12/03/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCustomNotification : UIView 


#pragma mark - Variables

//Taille du cercle
@property (assign, nonatomic) float size;

//Label pour afficher le nombre de notification
@property (strong, nonatomic) UILabel *labelNumberNotification;


#pragma mark - Fonctions

//On fait un popIn de la notification
- (void)popIn;

//On fait un popOut de la notification
- (void)popOut;

@end
