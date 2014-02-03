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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //On s'abonne à la notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(upPopOver:)
                                                 name:UP_POPOVER
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //On se désabonne de toutes les notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [self.view setAlpha:0];
    
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
    //Récupère la couche de la vue en question
    CALayer *viewLayer = self.viewContainer.layer;
    
    //Prépare l'animation en précisant quel valeur ba être changé au cours du temps
    CAKeyframeAnimation* popInAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    //On donne la durée de l'animation
    popInAnimation.duration = 0.35;
    
    //On précise les valeur que va prendre la propriété transform.scale
    popInAnimation.values = [NSArray arrayWithObjects:
                             [NSNumber numberWithFloat:0],
                             [NSNumber numberWithFloat:1.05],
                             [NSNumber numberWithFloat:0.95],
                             [NSNumber numberWithFloat:1],
                             nil];
    
    //On précise à quels moments les valeurs doivent être appliquées.
    popInAnimation.keyTimes = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0],
                               [NSNumber numberWithFloat:0.5],
                               [NSNumber numberWithFloat:0.7],
                               [NSNumber numberWithFloat:1.0],
                               nil];
    
    popInAnimation.delegate = self;
    
    [viewLayer addAnimation:popInAnimation forKey:@"AnimationDisplay"];
}

//On appuie sur la vue
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint touchLocation = [touch locationInView:self.view];
    
    if (CGRectContainsPoint(self.viewContainer.frame, touchLocation))
    {
        return NO;
    }
    //On dismiss le popUp si on ne touche pas la vue contenu
    else
    {
        [self hide];
        return YES;
    }
}

//On lance l'animation de disparition
- (void)hide
{
    //Récupère la couche de la vue en question
    CALayer *viewLayer = self.viewContainer.layer;
    
    //Prépare l'animation en précisant quel valeur ba être changé au cours du temps
    CAKeyframeAnimation* popOutAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    //On donne la durée de l'animation
    popOutAnimation.duration = 0.35;
    
    //On précise les valeur que va prendre la propriété transform.scale
    popOutAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:1.0],
                              [NSNumber numberWithFloat:1.1],
                              [NSNumber numberWithFloat:0.1],
                              nil];
    
    //On précise à quels moments les valeurs doivent être appliquées.
    popOutAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:0.0],
                                [NSNumber numberWithFloat:0.3],
                                [NSNumber numberWithFloat:1.0],
                                nil];
    
    popOutAnimation.delegate = self;
    
    [viewLayer addAnimation:popOutAnimation forKey:@"AnimationHide"];
}

//On monte le popUp ou on le descend
-(void)upPopOver:(NSNotification *) notification
{
    NSNumber *offset = [notification object];
    int originHeight = self.view.frame.size.height/2 - self.viewContainer.frame.size.height/2;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.viewContainer setFrame:CGRectMake(self.viewContainer.frame.origin.x, originHeight - offset.intValue, self.viewContainer.frame.size.width, self.viewContainer.frame.size.height)];
    }];
}


#pragma mark - CAAnimation delegate functions

//L'animation démarre
- (void)animationDidStart:(CAAnimation *)anim
{
    if ([self.view alpha] == 1.0)
    {
        [UIView animateWithDuration:0.35 animations:^{
            [self.view setAlpha:0];
        } completion:^(BOOL finished) {
            [self.viewContainer removeFromSuperview];
            [self.view removeFromSuperview];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.20 animations:^{
            [self.view setAlpha:1.0];
        }];
    }
}

@end
