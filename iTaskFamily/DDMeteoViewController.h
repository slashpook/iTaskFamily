//
//  DDMeteoViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 22/08/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCustomNavigationBarController.h"

@protocol DDMeteoViewProtocol <NSObject>

- (void)closeMeteoView;

@end

@interface DDMeteoViewController : UIViewController <DDCustomNavBarProtocol, UITextFieldDelegate>


#pragma mark - Variables

//Delegate de la vue
@property (weak, nonatomic) id<DDMeteoViewProtocol> delegate;

//Navigation bar
@property (strong, nonatomic) DDCustomNavigationBarController *custoNavBar;

//Label choix de la ville
@property (weak, nonatomic) IBOutlet UILabel *labelChoiceCity;

//TextField du choix de la ville
@property (weak, nonatomic) IBOutlet UITextField *textFieldChoiceCity;

//Label Titre de la ville en cours
@property (weak, nonatomic) IBOutlet UILabel *labelTitleActualCity;

//Label Description de la ville en cours
@property (weak, nonatomic) IBOutlet UILabel *labelDescActualCity;


#pragma mark - Fonctions

@end
