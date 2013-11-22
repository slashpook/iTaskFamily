//
//  DDPlayerView.m
//  iTaskFamily
//
//  Created by Damien DELES on 21/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDPlayerView.h"
#import "UIImage+ImageEffects.h"

@implementation DDPlayerView

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
    [self.labelNamePlayer setFont:POLICE_HEADER];
    [self.labelNamePlayer setTextColor:COULEUR_WHITE];
    [self.labelPointPlayer setFont:POLICE_HEADER];
    [self.labelPointPlayer setTextColor:COULEUR_WHITE];
    
    //On met un effet flou au header et bottom
    [self setBlurEffect];
}


#pragma mark - View fonctions

//On met un effet de flou sur le header et le bottom
- (void)setBlurEffect
{
    UIImage *imageOriginal = self.imageViewPlayer.image;
    
    //On fait les snapshots
    UIImage *imageHeader = [DDHelperController snapshotFromImage:imageOriginal withRect:self.imageViewHeader.frame];
    UIImage *imageBottom = [DDHelperController snapshotFromImage:imageOriginal withRect:self.imageViewBottom.frame];
    
    //On applique le flou
    imageHeader = [imageHeader applyBlurWithRadius:2 tintColor:COULEUR_BLUR_BLACK saturationDeltaFactor:0.8 maskImage:nil];
    imageBottom = [imageBottom applyBlurWithRadius:2 tintColor:COULEUR_BLUR_BLACK saturationDeltaFactor:0.8 maskImage:nil];
    
    //On rajoute les images à la vue
    [self.imageViewHeader setImage:imageHeader];
    [self.imageViewBottom setImage:imageBottom];
}

@end
