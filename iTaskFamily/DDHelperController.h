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

//Retourne un snapshot d'une partie de l'écran
+ (UIImage *)snapshotFromImage:(UIImage *)imageOriginal withRect:(CGRect)frameSnapshot;

@end
