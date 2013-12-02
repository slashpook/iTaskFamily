//
//  DDRootViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 20/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDRootViewController.h"
#import "DDHomeViewController.h"
#import "DDPlayerViewController.h"

@interface DDRootViewController ()

@end

@implementation DDRootViewController


#pragma mark - Fonctions de base

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Initialise les views de l'application
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _homeViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    _playerViewController = [storyboard instantiateViewControllerWithIdentifier:@"PlayerViewController"];
    
    //On initialise le currentViewController et on lui set le homeViewController de base
    _currentViewController = [[UIViewController alloc] init];
    [self setCurrentViewController:self.homeViewController];
    
    [self.viewContainer addSubview:self.currentViewController.view];
    
    [[self viewMenu] setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Controller fonctions

- (void)displayController:(UIViewController *)controller andSens:(int)sens
{
    //On crée le snapshot de la vue et on l'ajoute à la vue container
    UIView *viewSnapshot = [[self.currentViewController view] snapshotViewAfterScreenUpdates:YES];
    [self.viewContainer addSubview:viewSnapshot];
    
    //On insère la vue à afficher en dessous et on lui set une position
    [self.viewContainer insertSubview:controller.view belowSubview:viewSnapshot];
    [[controller view] setFrame:CGRectMake(controller.view.frame.origin.x, 768 * sens, controller.view.frame.size.width, controller.view.frame.size.height)];
    
    //On enlève la vue précédente
    [[self.currentViewController view] removeFromSuperview];
    
    [UIView animateWithDuration:0.3 animations:^{
        [viewSnapshot setFrame:CGRectMake(controller.view.frame.origin.x, 768 * -sens, controller.view.frame.size.width, controller.view.frame.size.height)];
        [[controller view] setFrame:CGRectMake(controller.view.frame.origin.x, 0, controller.view.frame.size.width, controller.view.frame.size.height)];
    } completion:^(BOOL finished) {
        [self setCurrentViewController:controller];
        [viewSnapshot removeFromSuperview];
    }];
}


#pragma mark - DDMenuViewProtocol fonctions

//On affiche la page d'accueil
- (void)openHomePage
{
    [self displayController:self.homeViewController andSens:-1];
}

//On affiche la page des joueurs
- (void)openPlayerPageWithSens:(int)sens
{
    [self displayController:self.playerViewController andSens:sens];
}

//On affiche la page des taches
- (void)openTaskPageWithSens:(int)sens
{
    
}

//On affiche la page des podiums
- (void)openPodiumPageWithSens:(int)sens
{
    
}

//On affiche la page des settings
- (void)openSettingPage
{
    
}

@end
