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
    Player *currentPlayer = [[DDManagerSingleton instance] currentPlayer];
    int totalTrophyCategory = (int)[[[DDDatabaseAccess instance] getTasksForCategory:self.category] count] * 3;
    int totalTrophyWin = [[DDDatabaseAccess instance] getNumberOfTrophyAchievedForPlayer:currentPlayer inCategory:self.category];
    NSString *weekAndYear = [DDHelperController getWeekAndYearForDate:[NSDate date]];
    int numberOfEvent = (int)[[[DDDatabaseAccess instance] getEventsForPlayer:currentPlayer atWeekAndYear:weekAndYear forCategory:self.category] count];
    
    //On met à jour les infos en fonction de la catégorie récupérée
    [self.labelLibelleCategory setText:self.category.libelle];
    [self.imageViewCategory setBackgroundColor:[[[DDManagerSingleton instance] dictColor] objectForKey:self.category.libelle]];
    [self.labelTrophyDesc setText:[NSString stringWithFormat:@"%i/%i", totalTrophyWin, totalTrophyCategory]];
    [self.labelPointDesc setText:[NSString stringWithFormat:@"%i", [[DDDatabaseAccess instance] getScoreTotalForPlayer:currentPlayer forCategory:self.category]]];
    [self.labelEventDesc setText:[NSString stringWithFormat:@"%i", numberOfEvent]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
