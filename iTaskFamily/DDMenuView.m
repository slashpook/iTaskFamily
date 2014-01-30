//
//  DDMenuView.m
//  iTaskFamily
//
//  Created by Damien DELES on 20/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDMenuView.h"
#import "DDPopOverViewController.h"
#import "Player.h"

@implementation DDMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    //On set la couleur de base des imageViews
    [self setBackgroundColor:COULEUR_BLACK];
    [self.imageViewLeftBar setBackgroundColor:COULEUR_HOME];
    [self.imageViewSelection setBackgroundColor:COULEUR_HOME];
    [self.imageViewBackgroundPlayer setBackgroundColor:COULEUR_HOME];
    
    //On configure le boutton pour sélectionner le joueur principal
    [self.buttonPlayer.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [[self.buttonPlayer layer] setCornerRadius:44.0];
    [[self.buttonPlayer layer] setMasksToBounds:true];
    
    //On enlève le toucher multiple sur le menu
    [self.subviews makeObjectsPerformSelector:@selector(setExclusiveTouch:) withObject:[NSNumber numberWithBool:YES]];
    
    //On récupère le storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //On initialise le popOver
    _popOverViewController = [storyboard instantiateViewControllerWithIdentifier:@"PopOverViewController"];
    [self.popOverViewController.view setBackgroundColor:COULEUR_TRANSPARENT_BLACK_FONCE];
    
    //On initialise le controller qui affiche la liste des joueurs
    _playerListViewController = [storyboard instantiateViewControllerWithIdentifier:@"PlayerListViewController"];
    [self.playerListViewController setDelegate:self];
    
    //On met à jour le joueur principal
    [self updateMainPlayer];
    
    //On met en place la notification pour modifier le joueur
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateMainPlayer)
                                                 name:UPDATE_PLAYER
                                               object:nil];
}


#pragma mark - View fonctions

//Switch on Home view
- (IBAction)onPushHomeButton:(UIButton *)sender
{
    //On vérifie que l'on est pas déjà sur la page courante
    if (self.imageViewSelection.frame.origin.y != [(UIButton *)sender frame].origin.y)
    {
        //On lance les animations
        [self setFrameImageSelection:sender.frame];
        [self setColorSelection:COULEUR_HOME];
        [self.delegate openHomePage];
    }
}

//Switch on Player view
- (IBAction)onPushPlayerButton:(UIButton *)sender
{
    //On vérifie que l'on est pas déjà sur la page courante
    if (self.imageViewSelection.frame.origin.y != [(UIButton *)sender frame].origin.y)
    {
        //On récupère le sens de l'animation
        int sens = 1;
        if (self.imageViewSelection.frame.origin.y > [(UIButton *)sender frame].origin.y)
            sens = -1;
        
        //On lance les animations
        [self setFrameImageSelection:sender.frame];
        [self setColorSelection:COULEUR_PLAYER];
        [self.delegate openPlayerPageWithSens:sens];
    }
}

//Switch on Task view
- (IBAction)onPushTaskButton:(UIButton *)sender
{
    //On vérifie que l'on est pas déjà sur la page courante
    if (self.imageViewSelection.frame.origin.y != [(UIButton *)sender frame].origin.y)
    {
        //On récupère le sens de l'animation
        int sens = 1;
        if (self.imageViewSelection.frame.origin.y > [(UIButton *)sender frame].origin.y)
            sens = -1;
        
        //On lance les animations
        //On lance les animations
        [self setFrameImageSelection:sender.frame];
        [self setColorSelection:COULEUR_TASK];
        [self.delegate openTaskPageWithSens:sens];
    }
}

//Switch on Trophy view
- (IBAction)onPushTrophyButton:(UIButton *)sender
{
    //On vérifie que l'on est pas déjà sur la page courante
    if (self.imageViewSelection.frame.origin.y != [(UIButton *)sender frame].origin.y)
    {
        //On récupère le sens de l'animation
        int sens = 1;
        if (self.imageViewSelection.frame.origin.y > [(UIButton *)sender frame].origin.y)
            sens = -1;
        
        //On lance les animations
        [self setFrameImageSelection:sender.frame];
        [self setColorSelection:COULEUR_PODIUM];
        [self.delegate openPodiumPageWithSens:sens];
    }
}

//Switch on Setting view
- (IBAction)onPushSettingButton:(UIButton *)sender
{
    //On vérifie que l'on est pas déjà sur la page courante
    if (self.imageViewSelection.frame.origin.y != [(UIButton *)sender frame].origin.y)
    {
        //On lance les animations
        [self setFrameImageSelection:sender.frame];
        [self setColorSelection:COULEUR_SETTING];
        [self.delegate openSettingPage];
    }
}

//On bouge la vue qui sélectionne la page
- (void)moveView:(CGRect)location andColor:(UIColor *)color
{
    //Lance l'animation et change la couleur en fonction du bouton sélectionné
    [self.imageViewSelection setFrame:location];
    [self.imageViewSelection setBackgroundColor:color];
    [self.imageViewLeftBar setBackgroundColor:color];
    [self.imageViewBackgroundPlayer setBackgroundColor:color];
}

//On ouvre la popUp pour changer de joueur
- (IBAction)onPushSelectPlayerButton:(UIButton *)sender
{
    if (self.currentPlayer != nil)
    {
        [[[[[[UIApplication sharedApplication] delegate] window] rootViewController] view] addSubview:self.popOverViewController.view];
        
        //On présente la popUp
        CGRect frame = self.playerListViewController.view.frame;
        [self.popOverViewController presentPopOverWithContentView:self.playerListViewController.view andSize:frame.size andOffset:CGPointMake(0, 0)];
    }
    else
    {
        //On affiche la page d'ajout de joueur
        [[NSNotificationCenter defaultCenter] postNotificationName:ADD_PLAYER object:nil];
    }
}

- (void)updateMainPlayer
{
    //On set le current player
    [self setCurrentPlayer:[[DDManagerSingleton instance] currentPlayer]];
    
    //Si on a un joueur on affiche l'image
    if (self.currentPlayer != nil)
    {
        [self.buttonPlayer setImage:[[[DDManagerSingleton instance] dictImagePlayer] objectForKey:self.currentPlayer.pseudo] forState:UIControlStateNormal];
        [self.buttonPlayer setBackgroundColor:[UIColor clearColor]];
    }
    else
    {
        [self.buttonPlayer setImage:[UIImage imageNamed:@"PlayerManageProfil"] forState:UIControlStateNormal];
        [self.buttonPlayer setBackgroundColor:COULEUR_WHITE];
    }
}


#pragma mark Fonctions de PlayerListViewProtocol

//On récupère le joueur sélectionné dans la liste
-(void)closePopOverPlayerListWithIndex:(int)index
{
    //Si on a cliqué sur un joueur, on met à jour
    if (index != - 1)
    {
        [self setCurrentPlayer:[[[DDDatabaseAccess instance] getPlayers] objectAtIndex:index]];
        [[DDManagerSingleton instance] setCurrentPlayer:self.currentPlayer];
        
        //On met à jour le joueur principal
        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_PLAYER object:nil];
    }
    
    //On enlève la popUp
    [self.popOverViewController hide];
}

@end
