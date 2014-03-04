//
//  DDHomeViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 20/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDPlayerView;
@class DDDateView;
@class DDMeteoView;
@class DDEventView;
@class DDMenuView;

@interface DDHomeViewController : UIViewController


#pragma mark - Variables

//View du player
@property (weak, nonatomic) IBOutlet DDPlayerView *viewPlayer;

//View de la date
@property (weak, nonatomic) IBOutlet DDDateView *viewDate;

//View de la météo
@property (weak, nonatomic) IBOutlet DDMeteoView *viewMeteo;

//View de l'event
@property (weak, nonatomic) IBOutlet DDEventView *viewEvent;

//Page control de la vue de joueur
@property (weak, nonatomic) IBOutlet UIPageControl *pageControlPlayer;


#pragma mark - Fonctions

@end
