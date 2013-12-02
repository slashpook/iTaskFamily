//
//  DDHelperController.h
//  iTaskFamily
//
//  Created by Damien DELES on 21/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDHelperController : NSObject


#pragma mark - Variables


#pragma mark - Fonctions

////SNAPSHO////
//Retourne un snapshot d'une partie de l'écran
+ (UIImage *)snapshotFromImage:(UIImage *)imageOriginal withRect:(CGRect)frameSnapshot;

//Retourne un snapshot d'une vue
+ (UIImage *)snapshotFromView:(UIView *)viewOriginal withRect:(CGRect)frameSnapshot;

////DATE////
//Récupère le jour en lettre
+ (NSString *)getDayInLetter;

//Récupère le numéro du jour
+ (NSString *)getDayInNumber;

//Récupère le mois en cours
+ (NSString *)getMonthInLetter;

//Récupère l'année en cours
+ (NSString *)getYearInLetter;

//Récupère l'heure en cours
+ (NSString *)getHour;

//Récupère les minutes en cours
+ (NSString *)getMin;

@end
