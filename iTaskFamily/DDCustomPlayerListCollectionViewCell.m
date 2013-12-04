//
//  CustomPlayerListCollectionViewCell.m
//  ITaskFamily
//
//  Created by DAMIEN on 20/11/12.
//  Copyright (c) 2012 INGESUP. All rights reserved.
//

#import "DDCustomPlayerListCollectionViewCell.h"

@implementation DDCustomPlayerListCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //On met le background à clear
        [self setBackgroundColor:[UIColor clearColor]];
        
        //On initialise le bouton
        _buttonPlayer = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.buttonPlayer setFrame:CGRectMake(5, 5, 240, 240)];
        [[self.buttonPlayer layer] setCornerRadius:10.0];
        [[self.buttonPlayer layer] setMasksToBounds:true];
        [self.buttonPlayer.imageView setContentMode:UIViewContentModeScaleAspectFill];

        _labelPseudo = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, 250, 21)];
        [self.labelPseudo setTextAlignment:NSTextAlignmentCenter];
        [self.labelPseudo setBackgroundColor:[UIColor clearColor]];
        [self.labelPseudo setFont:POLICE_TITLE];
        [self.labelPseudo setTextColor:COULEUR_WHITE];
        
        [self.contentView addSubview:self.buttonPlayer];
        [self.contentView addSubview:self.labelPseudo];
    }
    return self;
}

@end
