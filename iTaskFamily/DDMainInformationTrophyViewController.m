//
//  DDMainInformationTrophyViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 14/08/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDMainInformationTrophyViewController.h"
#import "DDCustomProgressBar.h"

@interface DDMainInformationTrophyViewController ()

@end

@implementation DDMainInformationTrophyViewController

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
    //On configure la police et la couleur des éléments
    [self.labelLibelleCategory setTextColor:COULEUR_WHITE];
    [self.labelLibelleCategory setFont:POLICE_EVENTINFO_BULLE];
    [self.labelTrophyTitle setTextColor:COULEUR_BLACK];
    [self.labelTrophyTitle setFont:POLICE_TROPHY_TITLE];
    [self.labelPointTitle setTextColor:COULEUR_BLACK];
    [self.labelPointTitle setFont:POLICE_TROPHY_TITLE];
    [self.labelEventTitle setTextColor:COULEUR_BLACK];
    [self.labelEventTitle setFont:POLICE_TROPHY_TITLE];
    [self.labelTrophyDesc setTextColor:COULEUR_BLACK];
    [self.labelTrophyDesc setFont:POLICE_TROPHY_CONTENT];
    [self.labelPointDesc setTextColor:COULEUR_BLACK];
    [self.labelPointDesc setFont:POLICE_TROPHY_CONTENT];
    [self.labelEventDesc setTextColor:COULEUR_BLACK];
    [self.labelEventDesc setFont:POLICE_TROPHY_CONTENT];
    [self.progressBarBronze setBackgroundColor:[UIColor clearColor]];
    [self.progressBarBronze setColorBackground:COULEUR_BLACK];
    [self.progressBarArgent setBackgroundColor:[UIColor clearColor]];
    [self.progressBarArgent setColorBackground:COULEUR_BLACK];
    [self.progressBarOr setBackgroundColor:[UIColor clearColor]];
    [self.progressBarOr setColorBackground:COULEUR_BLACK];
    
    //On set le radius des éléments
    [self.imageViewCategory.layer setCornerRadius:10.0];
}


#pragma mark - Fonctions du controller

//On met à jour la vue
- (void)updateComponent
{
    //On récupère les variables dont on a besoin
    Player *currentPlayer = [[DDManagerSingleton instance] currentPlayer];
    NSDictionary *dictColor = [[DDManagerSingleton instance] dictColor];
    
    int totalTrophyCategory = (int)[[[DDDatabaseAccess instance] getTasksForCategory:self.category] count] * 3;
    int totalTrophyWin = [[DDDatabaseAccess instance] getNumberOfTrophyAchievedForPlayer:currentPlayer inCategory:self.category];
    NSString *weekAndYear = [DDHelperController getWeekAndYearForDate:[NSDate date]];
    int numberOfEvent = (int)[[[DDDatabaseAccess instance] getEventsForPlayer:currentPlayer atWeekAndYear:weekAndYear forCategory:self.category] count];
    int numberOfTask = (int)[[[DDDatabaseAccess instance] getTasksForCategory:self.category] count];
    
    //On met à jour les infos qui ne bougeront pas si on a ou pas un joueur
    [self.labelLibelleCategory setText:self.category.libelle];
    [self.imageViewCategory setBackgroundColor:[[[DDManagerSingleton instance] dictColor] objectForKey:self.category.libelle]];
    [self.labelTotalBronze setText:[NSString stringWithFormat:@"%i", numberOfTask]];
    [self.progressBarBronze setCategory:self.category];
    [self.progressBarBronze setColorRealisation:[dictColor objectForKey:self.category.libelle]];
    [self.labelTotalArgent setText:[NSString stringWithFormat:@"%i", numberOfTask]];
    [self.progressBarArgent setCategory:self.category];
    [self.progressBarArgent setColorRealisation:[dictColor objectForKey:self.category.libelle]];
    [self.labelTotalOr setText:[NSString stringWithFormat:@"%i", numberOfTask]];
    [self.progressBarOr setCategory:self.category];
    [self.progressBarOr setColorRealisation:[dictColor objectForKey:self.category.libelle]];
    
    //Si on a un joueur
    if (currentPlayer != nil)
    {
        [self.labelTrophyDesc setText:[NSString stringWithFormat:@"%i/%i", totalTrophyWin, totalTrophyCategory]];
        [self.labelPointDesc setText:[NSString stringWithFormat:@"%i", [[DDDatabaseAccess instance] getScoreTotalForPlayer:currentPlayer forCategory:self.category]]];
        [self.labelEventDesc setText:[NSString stringWithFormat:@"%i", numberOfEvent]];
        [self.labelRealizedBronze setText:[NSString stringWithFormat:@"%i", [[DDDatabaseAccess instance] getNumberOfTrophyAchievedForPlayer:currentPlayer inCategory:self.category andType:@"Bronze"]]];
        [self.progressBarBronze setPlayer:currentPlayer];
        [self.progressBarBronze setTypeTrophy:@"Bronze"];
        [self.labelRealizedArgent setText:[NSString stringWithFormat:@"%i", [[DDDatabaseAccess instance] getNumberOfTrophyAchievedForPlayer:currentPlayer inCategory:self.category andType:@"Argent"]]];
        [self.progressBarArgent setPlayer:currentPlayer];
        [self.progressBarArgent setTypeTrophy:@"Argent"];
        [self.labelRealizedOr setText:[NSString stringWithFormat:@"%i", [[DDDatabaseAccess instance] getNumberOfTrophyAchievedForPlayer:currentPlayer inCategory:self.category andType:@"Or"]]];
        [self.progressBarOr setTypeTrophy:@"Or"];
        [self.progressBarOr setPlayer:currentPlayer];
    }
    else
    {
        [self.labelTrophyDesc setText:[NSString stringWithFormat:@"0/%i", totalTrophyCategory]];
        [self.labelPointDesc setText:@"0"];
        [self.labelEventDesc setText:@"0"];
        [self.labelRealizedBronze setText:@"0"];
        [self.progressBarBronze setCategory:nil];
        [self.progressBarBronze setPlayer:nil];
        [self.labelRealizedArgent setText:@"0"];
        [self.progressBarArgent setCategory:nil];
        [self.progressBarArgent setPlayer:nil];
        [self.labelRealizedOr setText:@"0"];
        [self.progressBarOr setCategory:nil];
        [self.progressBarOr setPlayer:nil];
    }
    
    //On rafraichis les progressbar
    [self.progressBarBronze setNeedsDisplay];
    [self.progressBarArgent setNeedsDisplay];
    [self.progressBarOr setNeedsDisplay];
}

@end
