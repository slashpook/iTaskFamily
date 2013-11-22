//
//  DDMeteoView.m
//  iTaskFamily
//
//  Created by Damien DELES on 22/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDMeteoView.h"
#import "DDWeatherInfos.h"

@implementation DDMeteoView

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
    
    //On set la police et la couleur des labels
    [self.labelMeteo setFont:POLICE_HEADER];
    [self.labelMeteo setTextColor:COULEUR_WHITE];
    
    //On met le header en couleur
    [self.imageViewHeader setBackgroundColor:COULEUR_BLACK];
}

@end
