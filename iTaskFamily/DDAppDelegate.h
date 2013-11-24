//
//  DDAppDelegate.h
//  iTaskFamily
//
//  Created by Damien DELES on 20/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDAppDelegate : UIResponder <UIApplicationDelegate>


#pragma mark - Variables

//Window de l'application
@property (strong, nonatomic) UIWindow *window;

//Booléen pour savoir si c'est le premier lancement de l'application ou non
@property (assign, nonatomic) BOOL isFirstLaunch;


#pragma mark - Fonctions
@end
