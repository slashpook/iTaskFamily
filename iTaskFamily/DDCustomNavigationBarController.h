//
//  DDCustomNavigationBarController.h
//  CoreDataTuto
//
//  Created by DAMIEN on 22/10/12.
//  Copyright (c) 2012 DAMIEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol DDCustomNavBarProtocol <NSObject>

@optional

//On appuie sur le bouton de droite
-(void)onPushRightBarButton;

//On appuie sur le bouton de gauche
-(void)onPushLeftBarButton;

@end

@interface DDCustomNavigationBarController : UIViewController


#pragma mark - Variables

//Delegate de la navigation bar
@property (weak, nonatomic) id<DDCustomNavBarProtocol>delegate;

//Bouton de gauche
@property (strong, nonatomic) UIButton *buttonLeft;

//Bouton de droite
@property (strong, nonatomic) UIButton *buttonRight;

//String du titre de la navigation bar
@property (strong, nonatomic) NSString *titre;

//Label du titre de la navigation bar
@property (strong, nonatomic) UILabel *lblTitre;

//Image du background de la tabBar
@property (strong, nonatomic) UIImage *imageBackground;

//ImageView du background de la tabBar
@property (strong, nonatomic) UIImageView *imageViewBackground;

//Couleur de fond de la navigation bar
@property (strong, nonatomic) UIColor *backgroundColorNavBar;


#pragma mark - Fonctions

//Initialisation de la navigationbar
- (id)initWithDelegate:(id<DDCustomNavBarProtocol>)delegate andTitle:(NSString *)title andBackgroundColor:(UIColor *)backgroundColor andImage:(UIImage *)imageBackground;

//On appuie sur le bouton de gauche
- (void)onPushLeftButton;

//On appuie sur le bouton de droite
- (void)onPushRightButton;

@end
