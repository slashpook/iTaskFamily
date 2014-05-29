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


#pragma mark - Date fonctions

//Récupère le jour en lettre
+ (NSString *)getDayInLetter
{
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"EEEE"];
    NSString *weekday = [formatter stringFromDate:today];

    return [weekday capitalizedString];
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
    [formatter setDateFormat: @"MMMM"];
    NSString *month = [formatter stringFromDate:today];
    
    return [[month substringToIndex:3] uppercaseString];
}

//Récupère la date à l'évènement donné
+ (NSString *)getDateInLetterForYear:(int)year week:(int)week andDay:(int)day
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

    //On configure un formatteur
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"EEEE dd MMMM YYYY"];
    
    //On renvoie la date
    return [NSString stringWithFormat:@"Semaine %i : %@", week, [formatter stringFromDate:date]];
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

//Récupère le numéro de la semaine
+ (NSString *)getWeek
{
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponent = [calender components:(NSWeekOfYearCalendarUnit |           NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
    
    //On gère le fait que la semaine doit toujours avoir 2 digit
    NSString *weakOfYear = nil;
    if (dateComponent.weekOfYear < 10)
        weakOfYear = [NSString stringWithFormat:@"0%i", (int)dateComponent.weekOfYear];
    else
        weakOfYear = [NSString stringWithFormat:@"%i", (int)dateComponent.weekOfYear];
    
    return weakOfYear;
}

//Récupère le weekAndYear actuel
+ (NSString *)getWeekAndYear
{
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponent = [calender components:(NSWeekOfYearCalendarUnit |           NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];

    //On gère le fait que la semaine doit toujours avoir 2 digit
    NSString *weakOfYear = nil;
    if (dateComponent.weekOfYear < 10)
        weakOfYear = [NSString stringWithFormat:@"0%i", (int)dateComponent.weekOfYear];
    else
        weakOfYear = [NSString stringWithFormat:@"%i", (int)dateComponent.weekOfYear];
    
    NSString *weekAndYearString = [NSString stringWithFormat:@"%i%@", (int)dateComponent.year, weakOfYear];
    
    return weekAndYearString;
}

//Récupère la semaine précédente
+ (NSString *)getPreviousWeek
{
//    // Start with some date, e.g. now:
//    NSDate *now = [NSDate date];
//    NSCalendar *cal = [NSCalendar currentCalendar];
//    
//    // Compute beginning of current week:
//    NSDate *date;
//    [cal rangeOfUnit:NSWeekCalendarUnit startDate:&date interval:NULL forDate:now];
//    
//    // Go back one week to get start of previous week:
//    NSDateComponents *comp1 = [[NSDateComponents alloc] init];
//    [comp1 setWeek:-1];
//    date = [cal dateByAddingComponents:comp1 toDate:date options:0];
//    
//    // Some output format (adjust to your needs):
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    [fmt setDateFormat:@"EEEE dd/MM/yyyy"];
//    
//    // Repeatedly add one day:
//    NSDateComponents *comp2 = [[NSDateComponents alloc] init];
//    [comp2 setDay:1];
//    for (int i = 1; i <= 7; i++) {
//        NSString *text = [fmt stringFromDate:date];
//        NSLog(@"%@", text);
//        date = [cal dateByAddingComponents:comp2 toDate:date options:0];
//        
//    }
    return nil;
}
@end
