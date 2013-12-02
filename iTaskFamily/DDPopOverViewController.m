//
//  DDPopOverViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 26/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDPopOverViewController.h"
#import "DDAppDelegate.h"

@interface DDPopOverViewController ()

@end

@implementation DDPopOverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //On colore le background du controller
    [self.view setBackgroundColor:COULEUR_TRANSPARENT_BLACK];
    
    _viewContainer = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Controller fonction

//On présente le popOver avec son contenu et sa position
- (void)presentPopOverWithContentView:(UIView *)contentView andSize:(CGSize)size andOffset:(CGPoint)offset
{
    //On crée la frame de la vue conteneur en fonction des données récupéré
    CGPoint centerScreenPoint = self.view.center;
    CGRect frameView = CGRectMake((centerScreenPoint.x - size.width/2) + offset.x, (centerScreenPoint.y - size.height/2) + offset.y, size.width, size.height);
    
    [self.viewContainer setFrame:frameView];

    //On set la frame à la nouvelle vue
    [contentView setFrame:frameView];
    
    //On set la nouvelle vue
    [self setViewContainer:contentView];
    [self.view addSubview:self.viewContainer];

    //On affiche la popUp
    [self display];
}

//On lance l'animation d'apparition
- (void)display
{
    //On récupère la frame finale
    CGRect finalFrame = self.viewContainer.frame;
   
    //On crée un snapshot de la vue
    UIImage *imageSnapshot = [DDHelperController snapshotFromView:self.viewContainer withRect:finalFrame];
    UIImageView *imageViewSnapshot = [[UIImageView alloc] initWithImage:imageSnapshot];
    
    //On set la frame de l'image pour quelle soit centré sans width ni height
    [imageViewSnapshot setFrame:CGRectMake(self.viewContainer.center.x, self.viewContainer.center.y, 0, 0)];
    
    //On ajoute le snapshot
    [self.view addSubview:imageViewSnapshot];
    
    //On cache la vue
    [self.viewContainer setAlpha:0.0];
    
    //On lance l'animation
    [UIView animateKeyframesWithDuration:0.60 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        //Première animation
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.15 animations:^{
            [imageViewSnapshot setFrame:CGRectMake(finalFrame.origin.x - 15, finalFrame.origin.y - 15, finalFrame.size.width + 30, finalFrame.size.height + 30)];
        }];
        
        //Seconde animation
        [UIView addKeyframeWithRelativeStartTime:0.15 relativeDuration:0.20 animations:^{
              [imageViewSnapshot setFrame:CGRectMake(finalFrame.origin.x + 10, finalFrame.origin.y + 15, finalFrame.size.width - 30, finalFrame.size.height - 30)];
        }];
        
        //Troisième animation
        [UIView addKeyframeWithRelativeStartTime:0.35 relativeDuration:0.25 animations:^{
            [imageViewSnapshot setFrame:finalFrame];
        }];
    } completion:^(BOOL finished) {
        //On remontre la vue
        [self.viewContainer setAlpha:1.0];
        //On enlève l'image du snapshot
        [imageViewSnapshot removeFromSuperview];
    }];
}

//On appuie sur la vue
- (IBAction)tapGestureTouched:(UITapGestureRecognizer *)sender
{
    //On récupère l'endroit ou on a appuyé
    CGPoint pointTouched = [sender locationInView:self.view];
    
    if (!CGRectContainsPoint(self.viewContainer.frame, pointTouched))
    {
        [self hide];
    }
}

//On lance l'animation de disparition
- (void)hide
{
    //On récupère la frame finale et du début
    CGRect originalFrame = self.viewContainer.frame;
    CGRect finalFrame = CGRectMake(self.viewContainer.center.x, self.viewContainer.center.y, 0, 0);
    
    //On crée un snapshot de la vue
    UIImage *imageSnapshot = [DDHelperController snapshotFromView:self.viewContainer withRect:originalFrame];
    UIImageView *imageViewSnapshot = [[UIImageView alloc] initWithImage:imageSnapshot];
    [imageViewSnapshot setFrame:self.viewContainer.frame];
    
    //On ajoute le snapshot
    [self.view addSubview:imageViewSnapshot];
    
    //On cache la vue
    [self.viewContainer setAlpha:0.0];
    
    //On lance l'animation
    [UIView animateKeyframesWithDuration:0.6 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        //Première animation -> on surgrossi l'image
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.3 animations:^{
            [imageViewSnapshot setFrame:CGRectMake(originalFrame.origin.x - 30, originalFrame.origin.y - 30, originalFrame.size.width + 60, originalFrame.size.height + 60)];
        }];
        
        //Seconde animation -> on met l'image à la bonne taille
        [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.3 animations:^{
            [self.view setAlpha:0.0];
            [imageViewSnapshot setFrame:finalFrame];
        }];
    } completion:^(BOOL finished) {
        //On enlève l'image du snapshot
        [imageViewSnapshot removeFromSuperview];
        [self.view setAlpha:1.0];
        [self.viewContainer setAlpha:1.0];
        //On enlève la popUp
        [self.view removeFromSuperview];
    }];
}


@end
