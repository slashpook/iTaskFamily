//
//  DDCustomButton.h
//  iTaskFamily
//
//  Created by Damien DELES on 16/05/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCustomButton : UIButton


#pragma mark - Variables

//Couleur du bouton quand il est enable
@property (strong, nonatomic) UIColor *colorTitleEnable;

//Couleur du bouton quand il est disable
@property (strong, nonatomic) UIColor *colorTitleDisable;

@end
