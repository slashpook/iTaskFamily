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
#import "DDTaskViewController.h"
#import "DDRootPodiumViewController.h"
#import "DDSettingViewController.h"

@interface DDRootViewController ()

@end

@implementation DDRootViewController


#pragma mark - Fonctions de base

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Initialise les views de l'application
    _homeViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"HomeViewController"];
    _playerViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"PlayerViewController"];
    _taskViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"TaskViewController"];
    _podiumViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"RootPodiumViewController"];
    _settingViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"SettingViewController"];
    
    //On initialise le currentViewController et on lui set le homeViewController de base
    _currentViewController = [[UIViewController alloc] init];
    [self setCurrentViewController:self.homeViewController];
    
    [self.viewContainer addSubview:self.currentViewController.view];
    
    [[self viewMenu] setDelegate:self];
    
    //On met en place la notification pour modifier le joueur
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onPushAddPlayer)
                                                 name:ADD_PLAYER
                                               object:nil];
    
    //On est pas en train d'animer
    [self setIsAnimating:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Controller fonctions

- (void)displayController:(UIViewController *)controller andSens:(int)sens
{
    if ([self isAnimating] == NO)
    {
        //On bloque les appels d'autres boutons
        [self setIsAnimating:YES];
        
        //On crée le snapshot de la vue et on l'ajoute à la vue container
        UIView *viewSnapshot;
        if (!SYSTEM_VERSION_LESS_THAN(@"7.0"))
            viewSnapshot = [[self.currentViewController view] snapshotViewAfterScreenUpdates:YES];
        else
            viewSnapshot = (UIView *)[DDHelperController snapshotFromView:self.currentViewController.view withRect:self.currentViewController.view.frame];
        
        [self.viewContainer addSubview:viewSnapshot];
        
        //On insère la vue à afficher en dessous et on lui set une position
        [self.viewContainer insertSubview:controller.view belowSubview:viewSnapshot];
        [[controller view] setFrame:CGRectMake(controller.view.frame.origin.x, 768 * sens, controller.view.frame.size.width, controller.view.frame.size.height)];
        
        //On enlève la vue précédente
        [[self.currentViewController view] removeFromSuperview];
        
        [UIView animateWithDuration:0.3 animations:^{
            [viewSnapshot setFrame:CGRectMake(controller.view.frame.origin.x, 768 * -sens, controller.view.frame.size.width, controller.view.frame.size.height)];
            [[controller view] setFrame:CGRectMake(controller.view.frame.origin.x, 0, controller.view.frame.size.width, controller.view.frame.size.height)];
            [[self viewMenu] moveView:self.viewMenu.frameImageSelection andColor:self.viewMenu.colorSelection];
        } completion:^(BOOL finished) {
            [self setCurrentViewController:controller];
            [viewSnapshot removeFromSuperview];
            
            //On permet aux boutons des autres menus d'être cliquables
            [self setIsAnimating:NO];
        }];
    }
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
    [self displayController:self.taskViewController andSens:sens];
}

//On affiche la page des podiums
- (void)openPodiumPageWithSens:(int)sens
{
    [self displayController:self.podiumViewController andSens:sens];
}

//On affiche la page des settings
- (void)openSettingPage
{
    [self displayController:self.settingViewController andSens:1];
}

//On affiche la page des joueurs avec la vue pour ajouter les joueurs
-(void)onPushAddPlayer
{
    [self.viewMenu onPushPlayerButton:self.viewMenu.buttonPlayerPage];
    [self.playerViewController onPushAddPlayer:nil];
}


@end
