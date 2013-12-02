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

@end
