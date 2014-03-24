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
@class DDCustomNotification;

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

//View notification Lundi
@property (weak, nonatomic) IBOutlet DDCustomNotification *viewNotificationLundi;

//View notification Mardi
@property (weak, nonatomic) IBOutlet DDCustomNotification *viewNotificationMardi;

//View notification Mercredi
@property (weak, nonatomic) IBOutlet DDCustomNotification *viewNotificationMercredi;

//View notification Jeudi
@property (weak, nonatomic) IBOutlet DDCustomNotification *viewNotificationJeudi;

//View notification Vendredi
@property (weak, nonatomic) IBOutlet DDCustomNotification *viewNotificationVendredi;

//View notification Samedi
@property (weak, nonatomic) IBOutlet DDCustomNotification *viewNotificationSamedi;

//View notification Dimanche
@property (weak, nonatomic) IBOutlet DDCustomNotification *viewNotificationDimanche;

//Tableau pour stocker toutes les notification et le manipuler plus facilement
@property (strong, nonatomic) NSArray *arrayWeekNotification;


#pragma mark - Fonctions

@end
