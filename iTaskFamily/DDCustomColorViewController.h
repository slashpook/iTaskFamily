//
//  DDCustomColorViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 21/08/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCustomNavigationBarController.h"

@class NKOColorPickerView;

@protocol DDCustomColorViewProtocol <NSObject>

- (void)closeCustomColorView;

@end

@interface DDCustomColorViewController : UIViewController <DDCustomNavBarProtocol>


#pragma mark - Variables

//Delegate de la vue
@property (weak, nonatomic) id<DDCustomColorViewProtocol> delegate;

//Navigation bar
@property (strong, nonatomic) DDCustomNavigationBarController *custoNavBar;

//Picker de couleur
@property (weak, nonatomic) IBOutlet NKOColorPickerView *colorPickerView;


#pragma mark - Fonctions


@end
