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
#import "DDCustomButton.h"

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
    
    //On initialise le popOver, et les controller qu'on affichera dedans
    _popOverViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"PopOverViewController"];
    _playerManagerViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"PlayerManagerViewController"];
    [self.playerManagerViewController setDelegate:self];
    _navigationPlayerManagerViewController = [[UINavigationController alloc] initWithRootViewController:self.playerManagerViewController];
    _rewardDetailViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"RewardDetailViewController"];
    [self.rewardDetailViewController setDelegate:self];
    
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
    
    //On met en place la notification pour mettre à jour le theme
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTheme)
                                                 name:UPDATE_THEME
                                               object:nil];
    
    [self updateTheme];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //On update les infos du joueurs si on en a un
    [self updateComponent];
}

- (void)viewDidAppear:(BOOL)animated
{
    //On cache ou non le boutton des récompenses
    [self updateComponentWithButtonReward];
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

//On affiche la récompense donnée
- (IBAction)onPushDisplayReward:(id)sender
{
    //On récupère le tableau des joueurs triés en fonction du score de la semaine passée
    NSArray *arrayTrophy = [[DDDatabaseAccess instance] getPlayersSortedByTypeScoreLastWeek];
    int index = [arrayTrophy indexOfObject:self.currentPlayer];
    
    Reward *reward = [[[DDDatabaseAccess instance] getRewardSortedForWeekAndYear:[DDHelperController getWeekAndYearForDate:[NSDate date]]] objectAtIndex:index];
    [self.rewardDetailViewController setReward:reward];
    [[[[[[UIApplication sharedApplication] delegate] window] rootViewController] view] addSubview:self.popOverViewController.view];
    
    //On présente la popUp
    CGRect frame = self.rewardDetailViewController.view.frame;
    [self.popOverViewController presentPopOverWithContentView:self.rewardDetailViewController.view andSize:frame.size andOffset:CGPointMake(0, 0)];
}

//On met à jour les infos du joueur
- (void)updateComponent
{
    //On met à jour le tableau des joueurs
    [self setArrayPlayer:[NSMutableArray arrayWithArray:[[DDDatabaseAccess instance] getPlayers]]];
   
    //On récupère une référence vers le trophyRootViewController
    DDRootTrophyViewController *rootTrophyViewController = [[self.rootTrophyNavigationViewController viewControllers] objectAtIndex:0];
    
    int totalTrophyCategory = (int)[[[DDDatabaseAccess instance] getTasks] count] * 3;
    
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
            self.currentPlayer = [[DDManagerSingleton instance] currentPlayer];

        //On configure les boutons de modification et suppression des joueur
        [self.buttonRemovePlayer setEnabled:YES];
        [self.buttonUpdatePlayer setEnabled:YES];
        
        //On met à jour les informations du joueur en cours
        [self.imageViewProfil setImage:[[[DDManagerSingleton instance] dictImagePlayer] objectForKey:self.currentPlayer.pseudo]];
        [self.labelNameProfil setText:self.currentPlayer.pseudo];
        int totalTrophyWin = [[DDDatabaseAccess instance] getNumberOfTrophyAchievedForPlayer:self.currentPlayer];
        [self.labelNbrTrophy setText:[NSString stringWithFormat:@"%i/%i",totalTrophyWin, totalTrophyCategory]];
        [self.labelWeekScore setText:[NSString stringWithFormat:@"%i",[[DDDatabaseAccess instance] getScoreWeekForPlayer:self.currentPlayer forWeekAndYear:[DDHelperController getWeekAndYearForDate:[NSDate date]]]]];
        [self.labelTotalScore setText:[NSString stringWithFormat:@"%i",[[DDDatabaseAccess instance] getScoreTotalForPlayer:self.currentPlayer]]];
    }
    else
    {
        [self.buttonRemovePlayer setEnabled:NO];
        [self.buttonUpdatePlayer setEnabled:NO];
        
        //On met à jour les informations du joueur en cours
        [self.imageViewProfil setImage:[UIImage imageNamed:@"PlayerProfil"]];
        [self.labelNameProfil setText:@"Aucun joueur"];
        [self.labelNbrTrophy setText:[NSString stringWithFormat:@"0/%i", totalTrophyCategory]];
        [self.labelWeekScore setText:@"0"];
        [self.labelTotalScore setText:@"0"];
    }
    
    //On update les trophées
    [rootTrophyViewController updateComponent];
    
    //On recharge la collection view
    [self.collectionViewMiniature reloadData];
}

- (void)updateComponentWithButtonReward
{
    //On récupère le tableau des joueurs triés en fonction du score de la semaine passée
    NSArray *arrayTrophy = [[DDDatabaseAccess instance] getPlayersSortedByTypeScoreLastWeek];
    int index = [arrayTrophy indexOfObject:self.currentPlayer];
    
    if (index != NSNotFound && [[[DDDatabaseAccess instance] getRewardSortedForWeekAndYear:[DDHelperController getWeekAndYearForDate:[NSDate date]]] objectAtIndex:index] != [NSNull null] && self.currentPlayer != nil)
    {
        [self.buttonReward setHidden:NO];
        [self.labelNameProfil setFrame:CGRectMake(25, 566, 350, 30)];
        [self.labelTitleTotalScore setFrame:CGRectMake(25, 596, 226, 21)];
        [self.labelTotalScore setFrame:CGRectMake(236, 596, 139, 21)];
        [self.labelTitleWeekScore setFrame:CGRectMake(25, 619, 226, 21)];
        [self.labelWeekScore setFrame:CGRectMake(236, 619, 139, 21)];
        [self.labelTitleNbrTrophy setFrame:CGRectMake(25, 642, 226, 21)];
        [self.labelNbrTrophy setFrame:CGRectMake(236, 642, 139, 21)];
        [self.labelTitleNbrTrophy setFont:POLICE_PLAYER_TITLE_REWARD];
        [self.labelTitleWeekScore setFont:POLICE_PLAYER_TITLE_REWARD];
        [self.labelTitleTotalScore setFont:POLICE_PLAYER_TITLE_REWARD];
        [self.labelNbrTrophy setFont:POLICE_PLAYER_CONTENT_REWARD];
        [self.labelWeekScore setFont:POLICE_PLAYER_CONTENT_REWARD];
        [self.labelTotalScore setFont:POLICE_PLAYER_CONTENT_REWARD];
    }
    else
    {
        [self.buttonReward setHidden:YES];
        [self.labelNameProfil setFrame:CGRectMake(25, 574, 350, 30)];
        [self.labelTitleTotalScore setFrame:CGRectMake(25, 618, 226, 21)];
        [self.labelTotalScore setFrame:CGRectMake(236, 618, 139, 21)];
        [self.labelTitleWeekScore setFrame:CGRectMake(25, 653, 226, 21)];
        [self.labelWeekScore setFrame:CGRectMake(236, 653, 139, 21)];
        [self.labelTitleNbrTrophy setFrame:CGRectMake(25, 687, 226, 21)];
        [self.labelNbrTrophy setFrame:CGRectMake(236, 687, 139, 21)];
        [self.labelTitleNbrTrophy setFont:POLICE_PLAYER_TITLE];
        [self.labelTitleWeekScore setFont:POLICE_PLAYER_TITLE];
        [self.labelTitleTotalScore setFont:POLICE_PLAYER_TITLE];
        [self.labelNbrTrophy setFont:POLICE_PLAYER_CONTENT];
        [self.labelWeekScore setFont:POLICE_PLAYER_CONTENT];
        [self.labelTotalScore setFont:POLICE_PLAYER_CONTENT];
    }
}

//On met à jour le theme
- (void)updateTheme
{
    [self.buttonReward setColorTitleEnable:[DDHelperController getMainTheme]];
    [self.buttonReward setNeedsDisplay];
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
    Player *player = [[DDDatabaseAccess instance] getPlayerAtIndex:(int)indexPath.row];
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


#pragma mark - DDRewardDetailViewProtocol fonctions

- (void)closeRewardDetailView
{
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
        [self setArrayPlayer:[NSMutableArray arrayWithArray:[[DDDatabaseAccess instance] getPlayers]]];
        
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
