//
//  DDHelperController.m
//  iTaskFamily
//
//  Created by Damien DELES on 21/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDHelperController.h"

@implementation DDHelperController


#pragma mark - Controller fonctions

//Retourne un snapshot d'une partie de l'écran
+ (UIImage *)snapshotFromImage:(UIImage *)imageOriginal withRect:(CGRect)frameSnapshot
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageOriginal CGImage], frameSnapshot);
    UIImage *imageSnapshot = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return imageSnapshot;
}

//Retourne un snapshot d'une vue
+ (UIImageView *)snapshotFromView:(UIView *)viewOriginal withRect:(CGRect)frameSnapshot
{
    //On fait un snapshot de la vue
    UIGraphicsBeginImageContext(frameSnapshot.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationLow);
    [viewOriginal.layer renderInContext:context];
    
    UIImage *imageSnapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIImageView *imageViewSnapshot = [[UIImageView alloc] initWithImage:imageSnapshot];
    UIGraphicsEndImageContext();
    
    return imageViewSnapshot;
}

//On sauvegarde la couleur dans les NSUserDefault
+ (void)saveThemeWithColor:(UIColor *)color
{
    NSData *savedColor = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults] setObject:savedColor forKey:@"mainColor"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//On récupère la couleur
+ (UIColor *)getMainTheme
{
    //On désarchive les données
    UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"mainColor"]];
    return color;
}

//On récupère le tutorial pour le chapitre donné
+ (NSMutableArray *)getTutorialForChapter:(int)chapter {
    NSMutableArray *arrayChapter;
    
    switch (chapter) {
        case 0: {
            arrayChapter = [NSMutableArray arrayWithObjects:NSLocalizedString(@"TUTO0-0", nil), nil];
        }
            break;
        case 1: {
            arrayChapter = [NSMutableArray arrayWithObjects:NSLocalizedString(@"TUTO1-0", nil), NSLocalizedString(@"TUTO1-1", nil), NSLocalizedString(@"TUTO1-2", nil), NSLocalizedString(@"TUTO1-3", nil), nil];
        }
            break;
        case 2: {
            arrayChapter = [NSMutableArray arrayWithObjects:NSLocalizedString(@"TUTO2-0", nil), NSLocalizedString(@"TUTO2-1", nil), nil];
        }
            break;
        case 3: {
            arrayChapter = [NSMutableArray arrayWithObjects:NSLocalizedString(@"TUTO3-0", nil), NSLocalizedString(@"TUTO3-1", nil), NSLocalizedString(@"TUTO3-2", nil), nil];
        }
            break;
        case 4: {
            arrayChapter = [NSMutableArray arrayWithObjects:NSLocalizedString(@"TUTO4-0", nil), NSLocalizedString(@"TUTO4-1", nil), NSLocalizedString(@"TUTO4-2", nil), nil];
        }
            break;
        case 5: {
            arrayChapter = [NSMutableArray arrayWithObjects:NSLocalizedString(@"TUTO5-0", nil), NSLocalizedString(@"TUTO5-1", nil), nil];
        }
            break;
        case 6: {
            arrayChapter = [NSMutableArray arrayWithObjects:NSLocalizedString(@"TUTO6-0", nil), nil];
        }
            break;
        case 7: {
            arrayChapter = [NSMutableArray arrayWithObjects:NSLocalizedString(@"TUTO7-0", nil), NSLocalizedString(@"TUTO7-1", nil), NSLocalizedString(@"TUTO7-2", nil), nil];
        }
            break;
        case 8: {
            arrayChapter = [NSMutableArray arrayWithObjects:NSLocalizedString(@"TUTO8-0", nil), NSLocalizedString(@"TUTO8-1", nil), NSLocalizedString(@"TUTO8-2", nil), nil];
        }
            break;
        case 9: {
            arrayChapter = [NSMutableArray arrayWithObjects:NSLocalizedString(@"TUTO9-0", nil), NSLocalizedString(@"TUTO9-1", nil), nil];
        }
            break;
        case 10: {
            arrayChapter = [NSMutableArray arrayWithObjects:NSLocalizedString(@"TUTO10-0", nil), NSLocalizedString(@"TUTO10-1", nil), NSLocalizedString(@"TUTO10-2", nil), nil];
        }
            break;

        default: {
            arrayChapter = [NSMutableArray arrayWithObjects:NSLocalizedString(@"TUTO0-0", nil), nil];
        }
            break;
    }

    return arrayChapter;
}


#pragma mark - Date fonctions

//Récupère le jour en lettre
+ (NSString *)getDayInLetter
{
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:today];
    NSInteger weekday = [weekdayComponents weekday];
    return [[[DDManagerSingleton instance] arrayWeek] objectAtIndex:(weekday - 1)];
}

//Récupère le numéro du jour
+ (NSString *)getDayInNumber
{
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"dd"];
    NSString *weekday = [formatter stringFromDate:today];
    
    return weekday;
}

//Récupère le mois en cours en abrégé
+ (NSString *)getShortMonthInLetter
{
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"M"];
    NSString *month = [[[DDManagerSingleton instance] arrayMonth] objectAtIndex:([[formatter stringFromDate:today] intValue] - 1)];
    
    return [[month substringToIndex:3] uppercaseString];
}

//Récupère l'année en cours
+ (NSString *)getYearInLetter
{
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"YYYY"];
    NSString *year = [formatter stringFromDate:today];
    
    return year;
}

//Récupère l'heure en cours
+ (NSString *)getHour
{
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"HH"];
    NSString *year = [formatter stringFromDate:today];
    
    return year;
}

//Récupère les minutes en cours
+ (NSString *)getMin
{
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"mm"];
    NSString *year = [formatter stringFromDate:today];
    
    return year;
}

//Récupère la date à l'évènement donné en lettre
+ (NSString *)getDateInLetterForDate:(NSDate *)date
{
    //On configure les formatters
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitYear) fromDate:date];
    NSInteger weekday = [weekdayComponents weekday];
    NSString *dayInLetter = [[[DDManagerSingleton instance] arrayWeek] objectAtIndex:(weekday - 1)];
    
    NSDateFormatter *formatterDayInNumber = [[NSDateFormatter alloc] init];
    [formatterDayInNumber setDateFormat: @"dd"];
    
    NSDateFormatter *formatterMonthInLetter = [[NSDateFormatter alloc] init];
    [formatterMonthInLetter setDateFormat: @"M"];
    NSString *monthInLetter = [[[DDManagerSingleton instance] arrayMonth] objectAtIndex:([[formatterMonthInLetter stringFromDate:date] intValue] - 1)];
    
    NSDateFormatter *formatterYear = [[NSDateFormatter alloc] init];
    [formatterYear setDateFormat: @"YYYY"];
    
    //On récupère le numéro de semaine
    NSString *stringWeek = [self getWeekForDate:date];
    
    //On renvoie la date
    return [NSString stringWithFormat:@"%@ %@ : %@ %@ %@ %i", NSLocalizedString(@"SEMAINE", nil), stringWeek, dayInLetter, [formatterDayInNumber stringFromDate:date], monthInLetter, (int)[weekdayComponents year]];
}

//Récupère la date à l'évènement donné en date
+ (NSDate *)getDateForYear:(int)year week:(int)week andDay:(int)day
{
    //On met à jour le jour (le premier jour n'est pas lundi mais dimanche)
    if (day == 7)
        day = 1;
    else
        day ++;
    
    //On récupère la date que l'on veut
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setLocale:[NSLocale currentLocale]];
    [calendar setFirstWeekday:2];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeekOfYear:week];
    [components setYearForWeekOfYear:year];
    [components setWeekday:day];
    NSDate *date = [calendar dateFromComponents:components];
    
    //On renvoie la date
    return date;
}

//Récupère le numéro de la semaine de la date donnée
+ (NSString *)getWeekForDate:(NSDate *)date
{
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponent = [calender components:(NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:date];
    
    //On gère le fait que la semaine doit toujours avoir 2 digit
    NSString *weakOfYear = nil;
    if (dateComponent.weekOfYear < 10)
        weakOfYear = [NSString stringWithFormat:@"0%i", (int)dateComponent.weekOfYear];
    else
        weakOfYear = [NSString stringWithFormat:@"%i", (int)dateComponent.weekOfYear];
    
    return weakOfYear;
}

//Récupère le weekAndYear de la date donnée
+ (NSString *)getWeekAndYearForDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponent = [calendar components:(NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:date];
    
    //On gère le fait que la semaine doit toujours avoir 2 digit
    NSString *weakOfYear = nil;
    int month = (int)dateComponent.month;
    
    if (dateComponent.weekOfYear < 10)
        weakOfYear = [NSString stringWithFormat:@"0%i", (int)dateComponent.weekOfYear];
    else
        weakOfYear = [NSString stringWithFormat:@"%i", (int)dateComponent.weekOfYear];
    
    NSString *weekAndYearString;
    
    if (month == 12 && [weakOfYear isEqualToString:@"01"])
        weekAndYearString = [NSString stringWithFormat:@"%i%@", ((int)dateComponent.year + 1), weakOfYear];
    else
        weekAndYearString = [NSString stringWithFormat:@"%i%@", (int)dateComponent.year, weakOfYear];
    
    return weekAndYearString;
}

//Récupère la date donnée avec l'écart
+ (NSDate *)getDateWithNumberOfDifferenceDay:(int)numberOfDifferenceDay forDate:(NSDate *)date
{
    //On crée le calendrier
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //On se met sur le premier jour de la semaine
    NSDate *newDate;
    
    //On reviens une semaine en arrière
    NSDateComponents *dateComponent = [[NSDateComponents alloc] init];
    [dateComponent setDay:numberOfDifferenceDay];
    newDate = [calendar dateByAddingComponents:dateComponent toDate:date options:0];
    
    return newDate;
}

//Récupère la semaine précédente de la date donnée
+ (NSDate *)getPreviousWeekForDate:(NSDate *)date
{
    NSDate *datePreviousWeek = [self getDateWithNumberOfDifferenceDay:-7 forDate:date];
    return datePreviousWeek;
}

//Récupère la semaine suivante de la date donnée
+ (NSDate *)getNextWeekForDate:(NSDate *)date
{
    NSDate *dateNextWeek = [self getDateWithNumberOfDifferenceDay:7 forDate:date];
    return dateNextWeek;
}

@end
