//
//  DDCustomCheckbox.h
//  iTaskFamily
//
//  Created by Damien DELES on 04/03/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCustomCheckbox : UIView


#pragma mark - Variables

//Booléen pour savoir si la checkbox est checkée
@property (assign, nonatomic) BOOL isChecked;

//Booléen pour savoir si la cellule de la checkbox est sélectionné
@property (assign, nonatomic) BOOL isSelected;

#pragma mark - Functions

@end
