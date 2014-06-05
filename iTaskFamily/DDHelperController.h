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


#pragma mark - Fonctions Snapshot

////SNAPSHOT////
//Retourne un snapshot d'une partie de l'écran
+ (UIImage *)snapshotFromImage:(UIImage *)imageOriginal withRect:(CGRect)frameSnapshot;

//Retourne un snapshot d'une vue
+ (UIImageView *)snapshotFromView:(UIView *)viewOriginal withRect:(CGRect)frameSnapshot;


#pragma mark - Fonctions Date

//Récupère le jour en lettre
+ (NSString *)getDayInLetter;

//Récupère le numéro du jour
+ (NSString *)getDayInNumber;

//Récupère le mois en cours en abrégé
+ (NSString *)getShortMonthInLetter;

//Récupère l'année en cours
+ (NSString *)getYearInLetter;

//Récupère l'heure en cours
+ (NSString *)getHour;

//Récupère les minutes en cours
+ (NSString *)getMin;

//Récupère la date à l'évènement donné en lettre
+ (NSString *)getDateInLetterForDate:(NSDate *)date;

//Récupère la date à l'évènement donné en date
+ (NSDate *)getDateForYear:(int)year week:(int)week andDay:(int)day;

//Récupère le numéro de la semaine de la date donnée
+ (NSString *)getWeekForDate:(NSDate *)date;

//Récupère le weekAndYear de la date donnée
+ (NSString *)getWeekAndYearForDate:(NSDate *)date;

//Récupère la date donnée avec l'écart
+ (NSDate *)getDateWithNumberOfDifferenceDay:(int)numberOfDifferenceDay forDate:(NSDate *)date;

//Récupère la semaine précédente de la date donnée
+ (NSDate *)getPreviousWeekForDate:(NSDate *)date;

//Récupère la semaine suivante de la date donnée
+ (NSDate *)getNextWeekForDate:(NSDate *)date;


@end
