//
//  DDHomeViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 20/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPlayerView.h"
#import "DDDateView.h"
#import "DDMenuView.h"

@interface DDHomeViewController : UIViewController


#pragma mark - Variables

//View du player
@property (weak, nonatomic) IBOutlet DDPlayerView *viewPlayer;

//View de la date
@property (weak, nonatomic) IBOutlet UIView *viewDate;

//View de la météo
@property (weak, nonatomic) IBOutlet UIView *viewMeteo;


#pragma mark - Fonctions

@end
