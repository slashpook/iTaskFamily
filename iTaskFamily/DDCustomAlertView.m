//
//  DDCustomAlertView.m
//  iTaskFamily
//
//  Created by Damien DELES on 29/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDCustomAlertView.h"

@implementation DDCustomAlertView

#pragma mark - Fonctions d'affichages

//Affiche un message d'information
+ (void)displayInfoMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Infos" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

//Affiche un message d'erreur
+ (void)displayErrorMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

//On affiche un message de confirmation
+ (void)displayAnswerMessage:(NSString *)message withDelegate:(id<UIAlertViewDelegate>)delegate
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:message delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:@"Non", nil];
    [alertView show];
}

//On affiche un message de confirmation et on modifie le tag
+ (void)displayAnswerMessage:(NSString *)message withDelegate:(id<UIAlertViewDelegate>)delegate andSetTag:(int)tagInfo
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:message delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:@"Non", nil];
    [alertView setTag:tagInfo];
    [alertView show];
}

//On affiche une alertView à 3 choix
+ (void)displayCustomMessage:(NSString *)message withDelegate:(id<UIAlertViewDelegate>)delegate andSetTag:(int)tagInfo withFirstChoice:(NSString *)firstChoice secondChoice:(NSString *)secondChoice andThirdChoice:(NSString *)thirdChoice
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:message delegate:delegate cancelButtonTitle:firstChoice otherButtonTitles:secondChoice, thirdChoice, nil];
    [alertView setTag:tagInfo];
    [alertView show];
}

@end
