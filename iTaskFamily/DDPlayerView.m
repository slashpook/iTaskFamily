//
//  DDPlayerView.m
//  iTaskFamily
//
//  Created by Damien DELES on 21/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDPlayerView.h"
#import "UIImage+ImageEffects.h"
#import "DDPopOverViewController.h"
#import "Player.h"

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
    
    //On met la couleur de background des view header et background
    [self.viewHeader setBackgroundColor:COULEUR_BLUR_BLACK];
    [self.viewBottom setBackgroundColor:COULEUR_BLUR_BLACK];
    
    //On set la police et la couleur des labels
    [self.labelNamePlayer setFont:POLICE_HEADER];
    [self.labelNamePlayer setTextColor:COULEUR_WHITE];
    [self.labelPointPlayer setFont:POLICE_HEADER];
    [self.labelPointPlayer setTextColor:COULEUR_WHITE];
    
    //On configure la scrollView
    self.scrollViewPlayer.pagingEnabled = YES;
    self.scrollViewPlayer.showsHorizontalScrollIndicator = NO;
    self.scrollViewPlayer.showsVerticalScrollIndicator = NO;
    self.scrollViewPlayer.scrollsToTop = NO;
    self.scrollViewPlayer.delegate = self;
    
    _arrayPlayer = [[NSMutableArray alloc] init];
    
    //On initialise le popOver
    _popOverViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"PopOverViewController"];
    [self.popOverViewController.view setBackgroundColor:COULEUR_TRANSPARENT_BLACK_FONCE];
    
    //On initialise le controller qui affiche la liste des joueurs
    _playerListViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"PlayerListViewController"];
    [self.playerListViewController setDelegate:self];
    
    //On met en place la notification pour modifier le joueur
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePlayer)
                                                 name:UPDATE_PLAYER
                                               object:nil];
}


#pragma mark - View fonctions

//On met un effet de flou sur le header et le bottom
- (void)setBlurEffectWithImage:(UIImage *)imageOriginal forButton:(UIButton *)button
{
    //On crée les frames pour le snapshot
    CGRect headerFrame = CGRectMake(0, 0, imageOriginal.size.width, SCALE_HEIGHT_BLUR * imageOriginal.size.height);
    CGRect bottomFrame = CGRectMake(0, (imageOriginal.size.height) - (SCALE_HEIGHT_BLUR * imageOriginal.size.height), imageOriginal.size.width, SCALE_HEIGHT_BLUR * imageOriginal.size.height);
    
    //On fait les snapshots
    UIImage *imageHeader = [DDHelperController snapshotFromImage:imageOriginal withRect:headerFrame];
    UIImage *imageBottom = [DDHelperController snapshotFromImage:imageOriginal withRect:bottomFrame];
    
    //On applique le flou
    imageHeader = [imageHeader applyBlurWithRadius:2 tintColor:COULEUR_BLUR_BLACK saturationDeltaFactor:0.8 maskImage:nil];
    imageBottom = [imageBottom applyBlurWithRadius:2 tintColor:COULEUR_BLUR_BLACK saturationDeltaFactor:0.8 maskImage:nil];
    
    //On crée les imageView
    UIImageView *imageViewHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 240, 50)];
    UIImageView *imageViewBottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, 190, 240, 50)];
    
    //On rajoute les images à la vue
    [imageViewHeader setImage:imageHeader];
    [imageViewBottom setImage:imageBottom];
    
    //On ajoute les images au bouton
    [button addSubview:imageViewHeader];
    [button addSubview:imageViewBottom];
    
    [self updatePlayer];
}

//On appuie sur le boutton pour ajouter un joueur
- (IBAction)onPushPlayer:(id)sender
{
    //Si on a des joueurs
    if ([self.arrayPlayer count] > 0)
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

//On met à jour le joueur
- (void)updatePlayer
{
    Player *currentPlayer = [[DDManagerSingleton instance] currentPlayer];
    int indexPlayer = [[[DDDatabaseAccess instance] getPlayers] indexOfObject:currentPlayer];
    [self.pageControl setCurrentPage:indexPlayer];
    
    //On reload la scrollView
    [self changePlayerInPageControl:self.pageControl];
    
    //On cache ou non les éléments suivant si on a un joueur ou non
    if (currentPlayer == nil)
    {
        [self.viewHeader setHidden:YES];
        [self.viewBottom setHidden:YES];
        [self.labelNamePlayer setHidden:YES];
        [self.labelPointPlayer setHidden:YES];
    }
    else
    {
        [self.viewHeader setHidden:NO];
        [self.viewBottom setHidden:NO];
        [self.labelNamePlayer setHidden:NO];
        [self.labelPointPlayer setHidden:NO];
    }
}



#pragma mark - ScrollView fonctions

//On appelle la fonction pour rafraichir le page control et la scroll view
- (void)refreshPageControlWithScrollView:(UIScrollView *)scrollView
{
    [self setArrayPlayer:[[DDDatabaseAccess instance] getPlayers]];
    
    //On enlève toutes les données présentes dans le scroll view
    [scrollView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    //On change la largeur de la scrollview pour qu'elle corresponde au nombre de données qu'il va contenir
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [self.arrayPlayer count], self.scrollViewPlayer.frame.size.height);
    
    //On donne à notre page control le nombre de page dont il aura besoin et quelle image on affiche
    self.pageControl.numberOfPages = [self.arrayPlayer count];
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    //Si il y a des joueurs
    if ([self.arrayPlayer count] > 0)
    {
        Player *player = [self.arrayPlayer objectAtIndex:self.pageControl.currentPage];
        
        //On change le joueur courant et on met à jour le menu
        [[DDManagerSingleton instance] setCurrentPlayer:player];
        
        //On met à jour les infos du joueur sur la page
        [self.labelNamePlayer setText:player.pseudo];
        [self.labelPointPlayer setText:[NSString stringWithFormat:@"%@ points", player.scoreSemaine]];
        
        //On charge la première page et la seconde pour éviter des problèmes d'affichage
        for (int i = 0; i < [self.arrayPlayer count]; i++)
            [self loadScrollViewWithPage:i];
        
        [self.buttonAddPlayer setHidden:YES];
    }
    else
    {
        //On rend le boutton d'ajout des évènements indisponible
        [self.labelNamePlayer setText:@""];
        [self.labelPointPlayer setText:@""];
        [self.buttonAddPlayer setHidden:NO];
    }
}

//On charge une image à la page donnée
- (void)loadScrollViewWithPage:(int)page
{
    //On teste si on peut afficher l'image (est ce qu'on est sur une page qui existe ou non)
    if (page < 0) return;
    if (page >= [self.arrayPlayer count]) return;
    
    //On donne à notre image view l'image correspondante
    UIButton *buttonProfil = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonProfil setImage:[[[DDManagerSingleton instance] dictImagePlayer] objectForKey:[[self.arrayPlayer objectAtIndex:page] pseudo]] forState:UIControlStateNormal];
    [buttonProfil setAdjustsImageWhenHighlighted:NO];
    [buttonProfil addTarget:self action:@selector(onPushPlayer:) forControlEvents:UIControlEventTouchUpInside];
    
    //On met un effet flou au header et bottom
    //[self setBlurEffectWithImage:[[[DDManagerSingleton instance] dictImagePlayer] objectForKey:[[self.arrayPlayer objectAtIndex:page] pseudo]] forButton:buttonProfil];
    
    //On rajoute le bouton à la scroll view
    if (nil == buttonProfil.superview)
    {
        //On crée un CGrect que l'on donnera à notre image pour bien la positionner
        CGRect frame = self.scrollViewPlayer.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        buttonProfil.frame = frame;
        [buttonProfil.imageView setContentMode:UIViewContentModeScaleAspectFill];
        
        //On ajoute notre bouton à la scrollview
        [self.scrollViewPlayer addSubview:buttonProfil];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //On rafraichis les données
    [self refreshPageControlWithScrollView:scrollView];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_PLAYER object:nil];
}

//Fonction utilisé pour mettre à jour les données du joueur
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //On regarde si on est à l'intérieur de la scrollview
    if (scrollView.contentOffset.x <= (scrollView.contentSize.width - 240) && scrollView.contentOffset.x > 0)
    {
        //On récupère l'alpha en fonction du scroll
        float alphaToChange = (cosf(2 * M_PI * fmod(scrollView.contentOffset.x, 240) / 240) + 1) * 0.5;
        
        //On affecte l'alpha aux labels
        [self.labelNamePlayer setAlpha:alphaToChange];
        [self.labelPointPlayer setAlpha:alphaToChange];
        
        //On récupère la page courante
        int currentPage = floor((scrollView.contentOffset.x - 240 / 2) / 240) + 1;
        
        //En fonction du sens de défilement ou charge le bon joueur
        if (currentPage > self.pageControl.currentPage)
        {
            if ((currentPage + 1) < [self.arrayPlayer count])
            {
                [self.labelNamePlayer setText:[[self.arrayPlayer objectAtIndex:currentPage + 1] pseudo]];
                [self.labelPointPlayer setText:[NSString stringWithFormat:@"%@ points", [[self.arrayPlayer objectAtIndex:currentPage + 1] scoreSemaine]]];
            }
        }
        else
        {
            [self.labelNamePlayer setText:[[self.arrayPlayer objectAtIndex:currentPage] pseudo]];
            [self.labelPointPlayer setText:[NSString stringWithFormat:@"%@ points", [[self.arrayPlayer objectAtIndex:currentPage] scoreSemaine]]];
        }
        
        self.pageControl.currentPage = currentPage;
    }
}

//On change le joueur quand on appuie sur le page control
- (IBAction)changePlayerInPageControl:(id)sender
{
    if ([self.arrayPlayer count] > 0)
    {
        [self.scrollViewPlayer setContentOffset:CGPointMake((self.scrollViewPlayer.contentSize.width / [self.arrayPlayer count]) * self.pageControl.currentPage, 0)];
        [self refreshPageControlWithScrollView:self.scrollViewPlayer];
    }
    else
        [self.scrollViewPlayer setContentOffset:CGPointMake(0, 0)];
}


#pragma mark Fonctions de PlayerListViewProtocol

//On récupère le joueur sélectionné dans la liste
-(void)closePopOverPlayerListWithIndex:(int)index
{
    //Si on a cliqué sur un joueur, on met à jour
    if (index != - 1)
    {
        [[DDManagerSingleton instance] setCurrentPlayer:[self.arrayPlayer objectAtIndex:index]];
        [self.pageControl setCurrentPage:index];
        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_PLAYER object:nil];
    }
    
    //On enlève la popUp
    [self.popOverViewController hide];
}

@end
