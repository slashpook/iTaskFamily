//
//  DDCustomAlertView.h
//  iTaskFamily
//
//  Created by Damien DELES on 29/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDCustomAlertView : NSObject


#pragma mark - Fonctions

//Affiche un message d'information
+ (void)displayInfoMessage:(NSString *)message;

//Affiche un message d'erreur
+ (void)displayErrorMessage:(NSString *)message;

//On affiche un message de confirmation
+ (void)displayAnswerMessage:(NSString *)message withDelegate:(id<UIAlertViewDelegate>)delegate;

//On affiche un message de confirmation et on modifie le tag
+ (void)displayAnswerMessage:(NSString *)message withDelegate:(id<UIAlertViewDelegate>)delegate andSetTag:(int)tagInfo;

//On affiche une alertView à 3 choix
+ (void)displayCustomMessage:(NSString *)message withDelegate:(id<UIAlertViewDelegate>)delegate andSetTag:(int)tagInfo withFirstChoice:(NSString *)firstChoice secondChoice:(NSString *)secondChoice andThirdChoice:(NSString *)thirdChoice;

@end
