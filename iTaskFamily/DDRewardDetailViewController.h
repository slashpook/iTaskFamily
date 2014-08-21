//
//  DDRewardDetailViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 21/08/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCustomNavigationBarController.h"

@protocol DDRewardDetailProtocol <NSObject>

- (void)closeRewardDetailView;

@end

@interface DDRewardDetailViewController : UIViewController <DDCustomNavBarProtocol>


#pragma mark - Variables

//Delegate de la vue
@property (weak, nonatomic) id<DDRewardDetailProtocol> delegate;

//Navigation bar
@property (strong, nonatomic) DDCustomNavigationBarController *custoNavBar;

//Reward à afficher
@property (strong, nonatomic) Reward *reward;

//Label pour afficher le reward
@property (weak, nonatomic) IBOutlet UILabel *labelReward;


#pragma mark - Fonctions

@end
