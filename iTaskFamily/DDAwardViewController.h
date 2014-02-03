//
//  DDAwardViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 03/02/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCustomNavigationBarController.h"

@protocol DDAwardViewProtocol <NSObject>

- (void)closeAwardView;

@end

@interface DDAwardViewController : UIViewController <DDCustomNavBarProtocol, UITextFieldDelegate>


#pragma mark - Variables

//Delegate de la vue
@property (weak, nonatomic) id<DDAwardViewProtocol> delegate;

//Navigation bar
@property (strong, nonatomic) DDCustomNavigationBarController *custoNavBar;

//Label de récompense du premier
@property (weak, nonatomic) IBOutlet UILabel *labelPremier;

//Textfield de récompense du premier
@property (weak, nonatomic) IBOutlet UITextField *textFieldPremier;

//Label de récompense du second
@property (weak, nonatomic) IBOutlet UILabel *labelSecond;

//Textfield de récompense du second
@property (weak, nonatomic) IBOutlet UITextField *textFieldSecond;

//Label de récompense du troisième
@property (weak, nonatomic) IBOutlet UILabel *labelTroisieme;

//Textfield de récompense du troisième
@property (weak, nonatomic) IBOutlet UITextField *textFieldTroisieme;


#pragma mark - Fonctions

@end
