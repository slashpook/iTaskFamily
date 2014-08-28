//
//  DDRootViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 20/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMenuView.h"

@class DDHomeViewController;
@class DDPlayerViewController;
@class DDTaskViewController;
@class DDRootPodiumViewController;
@class DDSettingViewController;

@interface DDRootViewController : UIViewController <DDMenuViewProtocol>


#pragma mark - Variables

//View du menu
@property (strong, nonatomic) IBOutlet DDMenuView *viewMenu;

//Home controller
@property (strong, nonatomic) UIViewController *currentViewController;

//La vue qui contient les viewController
@property (weak, nonatomic) IBOutlet UIView *viewContainer;

//Home controller
@property (strong, nonatomic) DDHomeViewController *homeViewController;

//Player controller
@property (strong, nonatomic) DDPlayerViewController *playerViewController;

//Task controller
@property (strong, nonatomic) DDTaskViewController *taskViewController;

//Podium controller
@property (strong, nonatomic) DDRootPodiumViewController *podiumViewController;

//Setting controller
@property (strong, nonatomic) DDSettingViewController *settingViewController;

//Booléen pour savoir si on est en train d'animer ou non
@property (assign, nonatomic) BOOL isAnimating;


#pragma mark - Fonctions

@end
