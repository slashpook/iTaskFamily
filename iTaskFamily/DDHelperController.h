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
+ (UIImageView *)snapshotFromView:(UIView *)viewOriginal withRect:(CGRect)frameSnapshot;

////DATE////
//Récupère le jour en lettre
+ (NSString *)getDayInLetter;

//Récupère le numéro du jour
+ (NSString *)getDayInNumber;

//Récupère le mois en cours en abrégé
+ (NSString *)getShortMonthInLetter;

//Récupère la date à l'évènement donné
+ (NSString *)getDateInLetterForYear:(int)year week:(int)week andDay:(int)day;

//Récupère l'année en cours
+ (NSString *)getYearInLetter;

//Récupère l'heure en cours
+ (NSString *)getHour;

//Récupère les minutes en cours
+ (NSString *)getMin;

//Récupère le numéro de la semaine
+ (NSString *)getWeek;

//Récupère le weekAndYear actuel
+ (NSString *)getWeekAndYear;

//Récupère la semaine précédente
+ (NSString *)getPreviousWeek;

@end
