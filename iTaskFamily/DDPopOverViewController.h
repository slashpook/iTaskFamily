//
//  DDPopOverViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 26/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDPopOverViewController : UIViewController


#pragma mark - Variables

//La vue qui contient les viewController
@property (strong, nonatomic) UIView *viewContainer;


#pragma mark - Fonctions

//On présente le popOver avec son contenu et sa position
- (void)presentPopOverWithContentView:(UIView *)contentView andSize:(CGSize)size andOffset:(CGPoint)offset;

//On lance l'animation de disparition
- (void)hide;

@end
