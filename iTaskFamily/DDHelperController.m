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
    float scale = [[UIScreen mainScreen] scale];
    CGRect finalFrame = CGRectMake(frameSnapshot.origin.x * scale, frameSnapshot.origin.y * scale, frameSnapshot.size.width * scale, frameSnapshot.size.height * scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageOriginal CGImage], finalFrame);
    UIImage *imageSnapshot = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return imageSnapshot;
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

//Récupère le mois en cours
+ (NSString *)getMonthInLetter
{
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"MMMM"];
    NSString *month = [formatter stringFromDate:today];
    
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
@end
