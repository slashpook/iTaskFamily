//
//  DDDateView.m
//  iTaskFamily
//
//  Created by Damien DELES on 21/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDDateView.h"

@implementation DDDateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    //On dessine la vue
    [self.layer setCornerRadius:10.0];
    [self.layer setMasksToBounds:YES];
    
    //On met le header en couleur
    [self.imageViewHeader setBackgroundColor:COULEUR_BARRE];
}

@end
