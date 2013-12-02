//
//  DDHomeViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 20/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDHomeViewController.h"

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
    [self.pageControlPlayer setTintColor:COULEUR_BLACK];
    [self.pageControlPlayer setCurrentPageIndicatorTintColor:COULEUR_HOME];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
