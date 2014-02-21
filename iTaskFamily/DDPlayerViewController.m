//
//  DDPlayerViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 25/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDPlayerViewController.h"
#import "DDPopOverViewController.h"
#import "DDPlayerMiniatureCollectionViewCell.h"
#import "DDRootTrophyViewController.h"
#import "Player.h"

@interface DDPlayerViewController ()

@end

@implementation DDPlayerViewController


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
    
    //On configure la vue des miniatures des joueurs
    [self.viewPlayerMiniature setBackgroundColor:COULEUR_WHITE];
    [self.viewPlayerMiniature.layer setCornerRadius:10.0];
    [self.viewPlayerMiniature.layer setMasksToBounds:YES];
    [self.viewBackgroundPlayerAction setBackgroundColor:COULEUR_BLACK];
    [self.viewBackgroundPlayerAction.layer setCornerRadius:10.0];
    
    //On configure la vue du profil
    [self.imageViewProfil setBackgroundColor:COULEUR_WHITE];
    [self.imageViewProfil.layer setCornerRadius:10];
    [self.imageViewProfil.layer setMasksToBounds:YES];
    
    //On configure la vue des trophées
    [self.viewRootContainer.layer setCornerRadius:10.0];
    [self.viewRootContainer.layer setMasksToBounds:YES];
    [self.viewHeaderTrophy setBackgroundColor:COULEUR_BLACK];
    
    //On configure les différentes polices
    [self.labelTitreTrophy setTextColor:COULEUR_WHITE];
    [self.labelTitreTrophy setFont:POLICE_HEADER];
    [self.labelNameProfil setTextColor:COULEUR_BLACK];
    [self.labelNameProfil setFont:POLICE_PLAYER_NAME];
    [self.labelTitleNbrTrophy setTextColor:COULEUR_BLACK];
    [self.labelTitleNbrTrophy setFont:POLICE_PLAYER_TITLE];
    [self.labelTitleWeekScore setTextColor:COULEUR_BLACK];
    [self.labelTitleWeekScore setFont:POLICE_PLAYER_TITLE];
    [self.labelTitleTotalScore setTextColor:COULEUR_BLACK];
    [self.labelTitleTotalScore setFont:POLICE_PLAYER_TITLE];
    [self.labelNbrTrophy setTextColor:COULEUR_BLACK];
    [self.labelNbrTrophy setFont:POLICE_PLAYER_CONTENT];
    [self.labelWeekScore setTextColor:COULEUR_BLACK];
    [self.labelWeekScore setFont:POLICE_PLAYER_CONTENT];
    [self.labelTotalScore setTextColor:COULEUR_BLACK];
    [self.labelTotalScore setFont:POLICE_PLAYER_CONTENT];
    
    //On initialise le popOver, le navigation controller et le playerManagerViewController
    _popOverViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"PopOverViewController"];
    _playerManagerViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"PlayerManagerViewController"];
    [self.playerManagerViewController setDelegate:self];
    _navigationPlayerManagerViewController = [[UINavigationController alloc] initWithRootViewController:self.playerManagerViewController];
    
    //On s'abonne a un type de cellule
    [self.collectionViewMiniature registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    //On récupère tous les joueurs
    _arrayPlayer = [[NSMutableArray alloc] init];
    
    //On récupère le joueur sélectionné
    [self setCurrentPlayer:[[DDManagerSingleton instance] currentPlayer]];
    
    //On met en place la notification pour modifier le joueur
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateComponent)
                                                 name:UPDATE_PLAYER
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //On update les infos du joueurs si on en a un
    [self updateComponent];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"PushRootTrophy"])
    {
        _rootTrophyNavigationViewController = (UINavigationController *)[segue destinationViewController];
    }
}

#pragma mark - Controller fonctions

//On ouvre la popUp pour ajouter une jouer
- (IBAction)onPushAddPlayer:(id)sender
{
    [self openNewPlayerView];
}

//On appuie sur le bouton pour supprimer le joueur sélectionné
- (IBAction)onPushDeletePlayer:(id)sender
{
    [DDCustomAlertView displayAnswerMessage:@"Voulez vous vraiment supprimer ce joueur ?" withDelegate:self];
}

//On appuie sur la modification du joueur
- (IBAction)onPushModifyPlayer:(id)sender
{
    [self openModifyPlayerView];
}

//On appuie sur l'image de profil
- (IBAction)onPushImageProfil:(id)sender
{
    //Si on a aucun joueur on ouvre la fenêtre d'ajout, sinon celle de modification
    if ([self.arrayPlayer count] == 0)
        [self openNewPlayerView];
    else
        [self openModifyPlayerView];
}

//On met à jour les infos du joueur
- (void)updateComponent
{
    //On met à jour le tableau des joueurs
    [self setArrayPlayer:[[DDDatabaseAccess instance] getPlayers]];
   
    //On récupère une référence vers le trophyRootViewController
    DDRootTrophyViewController *rootTrophyViewController = [[self.rootTrophyNavigationViewController viewControllers] objectAtIndex:0];
    
    //Suivant si on a des joueurs ou non, on applique des configurations différentes
    if ([self.arrayPlayer count] > 0)
    {
        //Si on vient de créer le joueur on le set
        if (self.currentPlayer == nil)
        {
            [[DDManagerSingleton instance] setCurrentPlayer:[[DDDatabaseAccess instance] getFirstPlayer]];
            self.currentPlayer = [[DDDatabaseAccess instance] getFirstPlayer];
            [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_PLAYER object:nil];
        }
        else
        {
            self.currentPlayer = [[DDManagerSingleton instance] currentPlayer];
        }
        
        
        
        //On configure les boutons de modification et suppression des joueur
        [self.buttonRemovePlayer setEnabled:YES];
        [self.buttonUpdatePlayer setEnabled:YES];
        
        //On met à jour les informations du joueur en cours
        [self.imageViewProfil setImage:[[[DDManagerSingleton instance] dictImagePlayer] objectForKey:self.currentPlayer.pseudo]];
        [self.labelNameProfil setText:self.currentPlayer.pseudo];
        [self.labelNbrTrophy setText:[self.currentPlayer.tropheesRealised stringValue]];
        [self.labelWeekScore setText:[self.currentPlayer.scoreSemaine stringValue]];
        [self.labelTotalScore setText:[self.currentPlayer.scoreTotal stringValue]];
        
        //On rend la tableView accessible
        [[self.rootTrophyNavigationViewController view] setUserInteractionEnabled:YES];
        [rootTrophyViewController.tableViewTrophy reloadData];
    }
    else
    {
        [self.buttonRemovePlayer setEnabled:NO];
        [self.buttonUpdatePlayer setEnabled:NO];
        
        //On met à jour les informations du joueur en cours
        [self.imageViewProfil setImage:[UIImage imageNamed:@"PlayerProfil"]];
        [self.labelNameProfil setText:@"Aucun joueur"];
        [self.labelNbrTrophy setText:@"0"];
        [self.labelWeekScore setText:@"0"];
        [self.labelTotalScore setText:@"0"];
        
        //On désactive la tableView
        [self.rootTrophyNavigationViewController popToRootViewControllerAnimated:YES];
        [[self.rootTrophyNavigationViewController view] setUserInteractionEnabled:NO];
        
        //On fait scroller la vue vers le haut
        [rootTrophyViewController.tableViewTrophy scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
    
    //On recharge la collection view
    [self.collectionViewMiniature reloadData];
}

//On ouvre la fenêtre de nouveau joueur
- (void)openNewPlayerView
{
    //On configure le controller
    [self.playerManagerViewController setIsModifyPlayer:NO];
    [self.playerManagerViewController setPlayer:nil];
    [self.playerManagerViewController updateComponent];
    
    //On ouvre la popUp
    [self openPlayerManagerViewController];
}

//On modifie le joueur
- (void)openModifyPlayerView
{
    //On configure le controller
    [self.playerManagerViewController setIsModifyPlayer:YES];
    [self.playerManagerViewController setPlayer:self.currentPlayer];
    [self.playerManagerViewController updateComponent];
    
    //On ouvre la popUp
    [self openPlayerManagerViewController];
}

//On ouvre la popUp
- (void)openPlayerManagerViewController
{
    //On pop le navigation controller
    [self.navigationPlayerManagerViewController popToRootViewControllerAnimated:NO];
    
    [[[[[[UIApplication sharedApplication] delegate] window] rootViewController] view] addSubview:self.popOverViewController.view];
    
    //On présente la popUp
    CGRect frame = self.playerManagerViewController.view.frame;
    [self.popOverViewController presentPopOverWithContentView:self.navigationPlayerManagerViewController.view andSize:frame.size andOffset:CGPointMake(0, 0)];
}


#pragma mark - UICollectionViewDelegate functions

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [self.arrayPlayer count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //On récupère le dictionnaire des images du joueur
    NSMutableDictionary *dictImagePlayer = [[DDManagerSingleton instance] dictImagePlayer];
    
    //On récupère la cellule
    DDPlayerMiniatureCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PlayerMiniatureCell" forIndexPath:indexPath];
    
    //On récupère le joueur
    Player *player = [self.arrayPlayer objectAtIndex:indexPath.row];
    
    //On configure l'image du joueur
    [cell.imageViewPlayer.layer setCornerRadius:10.0];
    [cell.imageViewPlayer.layer setMasksToBounds:YES];
    [cell.imageViewPlayer setContentMode:UIViewContentModeScaleAspectFill];
    [cell.imageViewPlayer setImage:[dictImagePlayer objectForKey:player.pseudo]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //On récupère le joueur et on le met à jour
    Player *player = [[DDDatabaseAccess instance] getPlayersAtIndex:indexPath.row];
    [[DDManagerSingleton instance] setCurrentPlayer:player];
    [self setCurrentPlayer:player];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_PLAYER object:nil];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


#pragma mark - DDPlayerManagerViewProtocol fonctions

- (void)closePlayerManagerView
{
    //On récupère tous les joueurs et on recharge les composants de la vue
    [self setArrayPlayer:[NSMutableArray arrayWithArray:[[DDDatabaseAccess instance] getPlayers]]];
    [self updateComponent];
    
    //On enlève la popUp
    [self.popOverViewController hide];
}


#pragma mark - UIAlerViewDelegate fonctions

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //si on a répondu oui, on supprime le joueur
    if (buttonIndex == 0)
    {
        [[DDDatabaseAccess instance] deletePlayer:self.currentPlayer];
        
        //On recharge le tableau des joueurs
        [self setArrayPlayer:[[DDDatabaseAccess instance] getPlayers]];
        
        //Si on a plus d'un joueur, on set le nouveau joueur
        if ([self.arrayPlayer count] > 0)
        {
            [self setCurrentPlayer:[self.arrayPlayer objectAtIndex:0]];
            [[DDManagerSingleton instance] setCurrentPlayer:self.currentPlayer];
        }
        else
        {
            [self setCurrentPlayer:nil];
            [[DDManagerSingleton instance] setCurrentPlayer:nil];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_PLAYER object:nil];
    }
}

@end
