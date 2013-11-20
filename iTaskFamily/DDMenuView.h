//
//  DDMenuView.h
//  iTaskFamily
//
//  Created by Damien DELES on 20/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDMenuView : UIView


#pragma mark - Variables

//Image view de la sélection
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelection;

//Image view de la barre de gauche
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLeftBar;


#pragma mark - Functions

//Switch on Home view
- (IBAction)onPushHomeButton:(UIButton *)sender;

//Switch on Player view
- (IBAction)onPushPlayerButton:(UIButton *)sender;

//Switch on Task view
- (IBAction)onPushTaskButton:(UIButton *)sender;

//Switch on Trophy view
- (IBAction)onPushTrophyButton:(UIButton *)sender;

//Switch on Setting view
- (IBAction)onPushSettingButton:(UIButton *)sender;

@end
