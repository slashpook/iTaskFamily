//
//  DDConstant.h
//  iTaskFamily
//
//  Created by Damien DELES on 20/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDConstant : NSObject


#pragma mark - Variables pour détecter sur quelle version d'iOS on se trouve

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


#pragma mark - Couleur de l'application

#define COULEUR_BLUR_WHITE [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]
#define COULEUR_BLUR_BLACK [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define COULEUR_TRANSPARENT_BLACK [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]
#define COULEUR_TRANSPARENT_BLACK_FONCE [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9]
#define COULEUR_TRANSPARENT [UIColor colorWithRed:0 green:0 blue:0 alpha:0]
#define COULEUR_BACKGROUND [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0]
#define COULEUR_HOME [UIColor colorWithRed:56/255.0 green:143/255.0 blue:218/255.0 alpha:1.0]
#define COULEUR_PLAYER [UIColor colorWithRed:36/255.0 green:199/255.0 blue:90/255.0 alpha:1.0]
#define COULEUR_TASK [UIColor colorWithRed:240/255.0 green:139/255.0 blue:0/255.0 alpha:1.0]
#define COULEUR_PODIUM [UIColor colorWithRed:137/255.0 green:60/255.0 blue:169/255.0 alpha:1.0]
#define COULEUR_SETTING [UIColor colorWithRed:225/255.0 green:51/255.0 blue:41/255.0 alpha:1.0]
#define COULEUR_BLACK [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]
#define COULEUR_WHITE [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0]
#define COULEUR_DISABLED [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]
#define COULEUR_AUTRE [UIColor colorWithRed:44/255.0 green:62/255.0 blue:80/255.0 alpha:1.0]
#define COULEUR_CHAMBRE [UIColor colorWithRed:230/255.0 green:126/255.0 blue:34/255.0 alpha:1.0]
#define COULEUR_CUISINE [UIColor colorWithRed:225/255.0 green:51/255.0 blue:41/255.0 alpha:1.0]
#define COULEUR_DOUCHE [UIColor colorWithRed:56/255.0 green:143/255.0 blue:218/255.0 alpha:1.0]
#define COULEUR_EXTERIEUR [UIColor colorWithRed:36/255.0 green:199/255.0 blue:90/255.0 alpha:1.0]
#define COULEUR_GARAGE [UIColor colorWithRed:241/255.0 green:196/255.0 blue:15/255.0 alpha:1.0]
#define COULEUR_SALON [UIColor colorWithRed:142/255.0 green:68/255.0 blue:173/255.0 alpha:1.0]
#define COULEUR_PLUS_UTILISE [UIColor colorWithRed:127/255.0 green:140/255.0 blue:141/255.0 alpha:1.0]
#define COULEUR_CELL_SELECTED [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0]
#define COULEUR_BORDER_CHECKBOX [UIColor colorWithRed:36/255.0 green:199/255.0 blue:90/255.0 alpha:1.0]


#pragma mark - Police de l'application

#define POLICE_HEADER [UIFont fontWithName:@"HelveticaNeue" size:35.0]
#define POLICE_TITLE [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0]
#define POLICE_DATE_BIG [UIFont fontWithName:@"HelveticaNeue-Thin" size:85.0]
#define POLICE_DATE_MEDIUM [UIFont fontWithName:@"HelveticaNeue-Thin" size:37.0]
#define POLICE_DATE_PONCTUATION [UIFont fontWithName:@"HelveticaNeue-Thin" size:45.0]
#define POLICE_METEO_BIG [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0]
#define POLICE_METEO_MEDIUM [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.0]
#define POLICE_EVENT_DAY [UIFont fontWithName:@"HelveticaNeue" size:20.0]
#define POLICE_EVENT_NO_PLAYER [UIFont fontWithName:@"HelveticaNeue-Thin" size:40.0]
#define POLICE_NAVBAR_BUTTON [UIFont fontWithName:@"HelveticaNeue" size:20.0]
#define POLICE_NAVBAR_TITLE [UIFont fontWithName:@"HelveticaNeue-Medium" size:22.0]
#define POLICE_PLAYER_NAME [UIFont fontWithName:@"HelveticaNeue-Medium" size:25.0]
#define POLICE_PLAYER_TITLE [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0]
#define POLICE_PLAYER_CONTENT [UIFont fontWithName:@"HelveticaNeue" size:17.0]
#define POLICE_CROPPER_TITLE [UIFont fontWithName:@"HelveticaNeue-Light" size:45.0]
#define POLICE_CROPPER_BUTTON [UIFont fontWithName:@"HelveticaNeue-Light" size:25.0]
#define POLICE_CATEGORY_MINIATURE [UIFont fontWithName:@"HelveticaNeue-Light" size:25.0]
#define POLICE_INFO_TACHE [UIFont fontWithName:@"HelveticaNeue-Light" size:25.0]
#define POLICE_INFO_TROPHE [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0]
#define POLICE_INFO_TROPHE_REALISED [UIFont fontWithName:@"HelveticaNeue-Light" size:25.0]
#define POLICE_TASK_TITLE [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0]
#define POLICE_TASK_CELL [UIFont fontWithName:@"HelveticaNeue" size:17.0]
#define POLICE_TASK_CONTENT [UIFont fontWithName:@"HelveticaNeue" size:17.0]
#define POLICE_AWARD_TITLE [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0]
#define POLICE_AWARD_CONTENT [UIFont fontWithName:@"HelveticaNeue" size:17.0]
#define POLICE_SETTING_CONTENT [UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0]
#define POLICE_EVENT_TITLE [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0]
#define POLICE_EVENT_CELL [UIFont fontWithName:@"HelveticaNeue" size:17.0]
#define POLICE_EVENT_CONTENT [UIFont fontWithName:@"HelveticaNeue" size:17.0]
#define POLICE_EVENT_TASK_NAME [UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0]
#define POLICE_EVENT_TASK_INFO [UIFont fontWithName:@"HelveticaNeue" size:13.0]


#pragma mark - Notification

#define UPDATE_METEO @"UPDATE_METEO"
#define UPDATE_DATE @"UPDATE_DATE"
#define UPDATE_PLAYER @"UPDATE_PLAYER"
#define ADD_PLAYER @"ADD_PLAYER"
#define UP_POPOVER @"UP_POPOVER"


#pragma mark - Jours de la semaine

#define LUNDI @"Lundi"
#define MARDI @"Mardi"
#define MERCREDI @"Mercredi"
#define JEUDI @"Jeudi"
#define VENDREDI @"Vendredi"
#define SAMEDI @"Samedi"
#define DIMANCHE @"Dimanche"
#define SEMAINE_ENTIERE @"Toute la semaine"
#define JOUR_SEMAINE @"Jours de la semaine"
#define WEEK_END @"Week end"


#pragma mark - Variables de la vue de podium

#define ORIGIN_SEPARATOR 465
#define HEIGHT_MAX_PODIUM 310


#pragma mark - Autres

#define PLUS_UTILISE @"Taches les plus utilisées"
#define SCALE_HEIGHT_BLUR 0.2083

@end
