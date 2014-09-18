//
//  DDAboutViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 17/09/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCustomNavigationBarController.h"

@protocol DDAboutViewProtocol <NSObject>

- (void)closeAboutView;

@end

@interface DDAboutViewController : UIViewController <DDCustomNavBarProtocol>


#pragma mark - Variables

//Delegate de la vue
@property (weak, nonatomic) id<DDAboutViewProtocol> delegate;

//Navigation bar
@property (strong, nonatomic) DDCustomNavigationBarController *custoNavBar;

//Label du copyright
@property (weak, nonatomic) IBOutlet UILabel *labelCopyright;

@end