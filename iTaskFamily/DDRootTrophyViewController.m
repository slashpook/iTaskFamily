//
//  DDRootTrophyViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 25/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDRootTrophyViewController.h"
#import "DDTrophyRootCell.h"

@interface DDRootTrophyViewController ()

@end

@implementation DDRootTrophyViewController

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
	
    //On configure le background de la vue
    [[self view] setBackgroundColor:COULEUR_WHITE];
    
    //On s'enregistre sur la classe de la cellule
    [self.tableViewTrophy registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    //On récupère le tableau des catégories
    _arrayCategory = [NSMutableArray arrayWithArray:[[DDDatabaseAccess instance] getCategoryTasks]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayCategory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //On récupère la catégorie à l'index donnée
    CategoryTask *category = [self.arrayCategory objectAtIndex:indexPath.row];
 
    //On récupère le nombre total de trophées pour la catégorie donnée
    int numberTotalTrophy = (int)[[[DDDatabaseAccess instance] getTasksForCategory:category] count] * 3;
    int numberBronzeTrophyRealised = 0;
    int numberArgentTrophyRealised = 0;
    int numberOrTrophyRealised = 0;
    int numberTotalTrophyRealised = 0;
    
    //On récupère le joueur sélectionné
    Player *player = [[DDManagerSingleton instance] currentPlayer];
    //Si le joueur existe on récupère le nombre de trophées qu'il a réalisé
    if (player != nil)
    {
        numberBronzeTrophyRealised = [[DDDatabaseAccess instance] getNumberOfTrophyAchievedForPlayer:player inCategory:category andType:@"Bronze"];
        numberArgentTrophyRealised = [[DDDatabaseAccess instance] getNumberOfTrophyAchievedForPlayer:player inCategory:category andType:@"Argent"];
        numberOrTrophyRealised = [[DDDatabaseAccess instance] getNumberOfTrophyAchievedForPlayer:player inCategory:category andType:@"Or"];
        numberTotalTrophyRealised = numberBronzeTrophyRealised + numberArgentTrophyRealised + numberOrTrophyRealised;
    }
    
    //On récupère la cellule
    DDTrophyRootCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrophyRootCell" forIndexPath:indexPath];
    
    //On configure la cellule
    [cell.viewCouleurCategory setBackgroundColor:[[[DDManagerSingleton instance] dictColor] objectForKey:category.libelle]];
    [cell.labelName setText:category.libelle];
    [cell.labelNumberTrophyCategory setText:[NSString stringWithFormat:@"%i/%i", numberTotalTrophyRealised ,numberTotalTrophy]];
    
    return cell;
}

@end
