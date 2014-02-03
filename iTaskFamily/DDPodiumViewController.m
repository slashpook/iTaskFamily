//
//  DDPodiumViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 31/01/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDPodiumViewController.h"
#import "Player.h"
#import "DDHistogramView.h"
#import "DDPopOverViewController.h"

@interface DDPodiumViewController ()

@end

@implementation DDPodiumViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //On initialise la couleur de la progressView
        _colorProgressView = [[UIColor alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //On configure les images des joueurs
    [self.imageViewPremier.layer setCornerRadius:55.0];
    [self.imageViewPremier.layer setMasksToBounds:YES];
    [self.imageViewSecond.layer setCornerRadius:55.0];
    [self.imageViewSecond.layer setMasksToBounds:YES];
    [self.imageViewTroisieme.layer setCornerRadius:55.0];
    [self.imageViewTroisieme.layer setMasksToBounds:YES];
    
    //On configure le bouton pour ajouter des récompenses
    [self.buttonAddReward.layer setCornerRadius:5.0];
    [self.buttonAddReward.layer setMasksToBounds:YES];
    
    //On initialise le tableau qui va contenir tous les éléments et on lui ajoutes des sous tableaux
    NSArray *arrayJoueur1 = [NSArray arrayWithObjects:self.labelTitrePremier, self.labelTitrePremierExposant, self.viewSeparationPremier, self.labelScorePremier, self.viewPremier, self.imageViewPremier, self.labelNomPremier, nil];
    NSArray *arrayJoueur2 = [NSArray arrayWithObjects:self.labelTitreSecond, self.labelTitreSecondExposant, self.viewSeparationSecond, self.labelScoreSecond, self.viewSecond, self.imageViewSecond, self.labelNomSecond, nil];
    NSArray *arrayJoueur3 = [NSArray arrayWithObjects:self.labelTitreTroisieme, self.labelTitreTroisiemeExposant, self.viewSeparationTroisieme, self.labelScoreTroisieme, self.viewTroisieme, self.imageViewTroisieme, self.labelNomTroisieme, nil];
    _arrayComponents = [[NSArray alloc] initWithObjects:arrayJoueur1, arrayJoueur2, arrayJoueur3, nil];
    
    //On récupère le storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //On initialise le popOver, le navigation controller et le AwardViewController
    _popOverViewController = [storyboard instantiateViewControllerWithIdentifier:@"PopOverViewController"];
    _awardViewController = [storyboard instantiateViewControllerWithIdentifier:@"AwardViewController"];
    [self.awardViewController setDelegate:self];
    _navigationAwardController = [[UINavigationController alloc] initWithRootViewController:self.awardViewController];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Controller fonctions

//Fonctions pour mettre à jour les composants
- (void)updateComponentsAndDisplayProgressBar:(BOOL)display
{
    //On récupère le tableau des joueurs
    NSMutableArray *arrayPlayer = [[DDDatabaseAccess instance] getPlayers];
    
    //On crée une variable pour récupérer le plus haut score
    int highScore;
    
    //On boucle sur le podium
    for (int i = 0; i<3; i++)
    {
        //On récupère le tableau des composants par titre
        NSArray *arrayComponent = [self.arrayComponents objectAtIndex:i];
        
        UILabel *labelTitre = (UILabel *)[arrayComponent objectAtIndex:0];
        UILabel *labelTitreExposant = (UILabel *)[arrayComponent objectAtIndex:1];
        UIView *viewSeparation = (UIView *)[arrayComponent objectAtIndex:2];
        UILabel *labelScore = (UILabel *)[arrayComponent objectAtIndex:3];
        DDHistogramView *progressView = (DDHistogramView *)[arrayComponent objectAtIndex:4];
        UIImageView *imageViewProfil = (UIImageView *)[arrayComponent objectAtIndex:5];
        UILabel *labelPseudo = (UILabel *)[arrayComponent objectAtIndex:6];
        
        //On récupère le joueur s'il existe
        Player *player = nil;
        if ([arrayPlayer count] > i)
        {
            //On crée une variable pour appliquer un pourcentage sur la couleur et la hauteur
            float pourcentOfHighNumber = 1.0;
            
            //On récupère le joueur
            player = [arrayPlayer objectAtIndex:i];
            
#warning - A enlever quand on aura des vraies données
            if (i == 0)
                [player setScoreSemaine:[NSNumber numberWithInt:4800]];
            else if (i == 1)
                [player setScoreSemaine:[NSNumber numberWithInt:3000]];
            else
                [player setScoreSemaine:[NSNumber numberWithInt:1200]];
            
            int height = HEIGHT_MAX_PODIUM;

            //Si on est sur le premier, on récupère son score
            if (i == 0)
                highScore = player.scoreSemaine.intValue;
            //On calcule quel est le pourcentage du score vis à vis du premier
            else
                pourcentOfHighNumber = player.scoreSemaine.floatValue / highScore;
            
            //Mise à jour du titre et du score
            [labelScore setText:[NSString stringWithFormat:@"%@ points", player.scoreSemaine]];
            
            //Mise à jour de la Progression
            [progressView setColorView:self.colorProgressView];
            [progressView setBackgroundColor:[UIColor clearColor]];
            [progressView setNeedsDisplay];
            [progressView setAlpha:(pourcentOfHighNumber + (pourcentOfHighNumber * 0.25))];
            
            //On reset les frames des éléments
            [progressView setFrame:CGRectMake(progressView.frame.origin.x, ORIGIN_SEPARATOR, progressView.frame.size.width, 0)];
            [labelScore setFrame:CGRectMake(labelScore.frame.origin.x, progressView.frame.origin.y - (labelScore.frame.size.height + 10), labelScore.frame.size.width, labelScore.frame.size.height)];
            [viewSeparation setFrame:CGRectMake(viewSeparation.frame.origin.x, labelScore.frame.origin.y - viewSeparation.frame.size.height, viewSeparation.frame.size.width, viewSeparation.frame.size.height)];
            [labelTitre setFrame:CGRectMake(labelTitre.frame.origin.x, viewSeparation.frame.origin.y - labelTitre.frame.size.height, labelTitre.frame.size.width, labelTitre.frame.size.height)];
            [labelTitreExposant setFrame:CGRectMake(labelTitreExposant.frame.origin.x, labelTitre.frame.origin.y, labelTitreExposant.frame.size.width, labelTitreExposant.frame.size.height)];
            
            //Si on doit tout afficher, on lance l'animation
            if (display == YES)
            {
                [UIView animateWithDuration:0.8 animations:^{
                    [progressView setFrame:CGRectMake(progressView.frame.origin.x, ORIGIN_SEPARATOR - (height * pourcentOfHighNumber), progressView.frame.size.width, (height * pourcentOfHighNumber))];
                    [labelScore setFrame:CGRectMake(labelScore.frame.origin.x, progressView.frame.origin.y - (labelScore.frame.size.height + 10), labelScore.frame.size.width, labelScore.frame.size.height)];
                    [viewSeparation setFrame:CGRectMake(viewSeparation.frame.origin.x, labelScore.frame.origin.y - viewSeparation.frame.size.height, viewSeparation.frame.size.width, viewSeparation.frame.size.height)];
                    [labelTitre setFrame:CGRectMake(labelTitre.frame.origin.x, viewSeparation.frame.origin.y - labelTitre.frame.size.height, labelTitre.frame.size.width, labelTitre.frame.size.height)];
                    [labelTitreExposant setFrame:CGRectMake(labelTitreExposant.frame.origin.x, labelTitre.frame.origin.y, labelTitreExposant.frame.size.width, labelTitreExposant.frame.size.height)];
                    
                    //On redessine la progressView
                    [progressView setNeedsDisplay];
                }];
            }

            //Mise à jour de l'image du joueur
            [imageViewProfil setImage:[[[DDManagerSingleton instance] dictImagePlayer] objectForKey:player.pseudo]];
            imageViewProfil.layer.borderColor = self.colorProgressView.CGColor;
            if ([[[[DDManagerSingleton instance] currentPlayer] pseudo] isEqualToString:player.pseudo])
                imageViewProfil.layer.borderWidth = 2;
            else
                imageViewProfil.layer.borderWidth = 0;
 
            //Mise à jour du nom du joueur
            [labelPseudo setText:player.pseudo];
        }
        else
        {
            //On reset les données
            [labelScore setText:@"0 points"];
            [imageViewProfil setImage:[UIImage imageNamed:@"PlayerManageProfil"]];
            [labelPseudo setText:@"Non défini"];
        }
    }
}

//Fonction pour ajouter une récompense
- (IBAction)onPushAddAward:(id)sender
{
    //On pop le navigation controller
    [self.navigationAwardController popToRootViewControllerAnimated:NO];
    
    [[[[[[UIApplication sharedApplication] delegate] window] rootViewController] view] addSubview:self.popOverViewController.view];
    
    //On présente la popUp
    CGRect frame = self.awardViewController.view.frame;
    [self.popOverViewController presentPopOverWithContentView:self.navigationAwardController.view andSize:frame.size andOffset:CGPointMake(0, 0)];
}


#pragma mark - DDAwardViewProtocol fonctions

//Fonction pour fermer la popUp
- (void)closeAwardView
{
    //On enlève la popUp
    [self.popOverViewController hide];
}

@end
