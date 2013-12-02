//
//  DDCustomNavigationBarController.m
//  CoreDataTuto
//
//  Created by DAMIEN on 22/10/12.
//  Copyright (c) 2012 DAMIEN. All rights reserved.
//

#import "DDCustomNavigationBarController.h"

@interface DDCustomNavigationBarController ()

@end

@implementation DDCustomNavigationBarController


#pragma mark Fonctions de base

- (id)initWithDelegate:(id<DDCustomNavBarProtocol>)delegate andTitle:(NSString *)title andBackgroundColor:(UIColor *)backgroundColor andImage:(UIImage *)imageBackground
{
    self = [super init];
    if (self) {
        [self setDelegate:delegate];
        [self setTitre:title];
        [self setBackgroundColorNavBar:backgroundColor];
        [self setImageBackground:imageBackground];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:self.backgroundColorNavBar];
    
    //On crée le bouton de gauche
    _buttonLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buttonLeft setFrame:CGRectMake(10, 5, 85, 40)];
    [[self.buttonLeft titleLabel] setTextColor:COULEUR_WHITE];
    [self.buttonLeft addTarget:self action:@selector(onPushLeftButton) forControlEvents:UIControlEventTouchUpInside];
    
    //On crée le bouton de droite
    _buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buttonRight setFrame:CGRectMake(285, 5, 85, 40)];
    [[self.buttonRight titleLabel] setTextColor:COULEUR_WHITE];
    [self.buttonRight addTarget:self action:@selector(onPushRightButton) forControlEvents:UIControlEventTouchUpInside];
   
    //On crée le titre
    _lblTitre = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 380, 50)];
    [self.lblTitre setTextAlignment:NSTextAlignmentCenter];
    [self.lblTitre setTextColor:COULEUR_WHITE];
    [self.lblTitre setBackgroundColor:[UIColor clearColor]];
    [self.lblTitre setText:self.titre];
    
    //On crée l'imageView
    _imageViewBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self.imageViewBackground setCenter:self.lblTitre.center];
    [self.imageViewBackground setImage:self.imageBackground];
    
    //On set la police
    [self.lblTitre setFont:POLICE_NAVBAR_TITLE];
    [[self.buttonLeft titleLabel] setFont:POLICE_NAVBAR_BUTTON];
    [[self.buttonRight titleLabel] setFont:POLICE_NAVBAR_BUTTON];

    [self.view addSubview:self.imageViewBackground];
    [self.view addSubview:self.lblTitre];
    [self.view addSubview:self.buttonLeft];
    [self.view addSubview:self.buttonRight];
}

//On appuie sur le bouton de gauche
- (void)onPushLeftButton
{
    [self.delegate onPushLeftBarButton];
}

//On appuie sur le bouton de droite
- (void)onPushRightButton
{
    [self.delegate onPushRightBarButton];
}

@end
