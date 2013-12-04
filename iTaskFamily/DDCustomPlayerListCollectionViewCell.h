//
//  CustomPlayerListCollectionViewCell.h
//  ITaskFamily
//
//  Created by DAMIEN on 20/11/12.
//  Copyright (c) 2012 INGESUP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCustomPlayerListCollectionViewCell : UICollectionViewCell


#pragma mark - Variables

//Image du perso
@property(strong, nonatomic) UIButton *buttonPlayer;

//Label du perso
@property(strong, nonatomic) UILabel *labelPseudo;

@end
