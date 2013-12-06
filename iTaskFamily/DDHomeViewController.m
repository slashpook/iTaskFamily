//
//  DDHomeViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 20/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDHomeViewController.h"
#import "DDPlayerView.h"
#import "Player.h"

@interface DDHomeViewController ()

@end

@implementation DDHomeViewController


#pragma mark - Fonctions de base

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
	
    //On set le background de la vue
    [[self view] setBackgroundColor:COULEUR_BACKGROUND];
    
    //On configure le pageControl
    if ([self.pageControlPlayer respondsToSelector:@selector(setTintColor:)])
    {
        [self.pageControlPlayer setTintColor:COULEUR_BLACK];
        [self.pageControlPlayer setCurrentPageIndicatorTintColor:COULEUR_HOME];
    }
    
    //On set le pageControl à la vue
    [self.viewPlayer setPageControl:self.pageControlPlayer];
    [self.pageControlPlayer addTarget:self.viewPlayer action:@selector(changePlayerInPageControl:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    //On recharge la scrollView
    [self.viewPlayer refreshPageControlWithScrollView:self.viewPlayer.scrollViewPlayer];
    [self.viewPlayer updatePlayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Controller function


@end
