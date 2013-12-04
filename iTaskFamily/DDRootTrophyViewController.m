//
//  DDRootTrophyViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 25/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDRootTrophyViewController.h"
#import "DDTrophyRootCell.h"
#import "Categories.h"
#import "Player.h"

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
    _arrayCategory = [NSMutableArray arrayWithArray:[[DDDatabaseAccess instance] getCategories]];
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
    Categories *categories = [self.arrayCategory objectAtIndex:indexPath.row];
 
    //On récupère le nombre total de trophées pour la catégorie donnée
    int numberTotalTrophy = [categories.task count] * 3;
    int numberTotalTrophyRealised = 0;
    
    //On récupère le joueur sélectionné
    Player *player = [[DDManagerSingleton instance] currentPlayer];
    //Si le joueur existe on récupère le nombre de trophées qu'il a réalisé
    if (player != nil)
    {
        numberTotalTrophyRealised = [[DDDatabaseAccess instance] getNumberOfTrophiesRealizedForPlayer:player inCategory:categories];
    }
    
    //On récupère la cellule
    DDTrophyRootCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrophyRootCell" forIndexPath:indexPath];
    
    //On configure la cellule
    [cell.viewCouleurCategory setBackgroundColor:[[[DDManagerSingleton instance] dictColor] objectForKey:categories.name]];
    [cell.labelName setText:categories.name];
    [cell.labelNumberTrophyCategory setText:[NSString stringWithFormat:@"%i/%i", numberTotalTrophyRealised ,numberTotalTrophy]];
    
    
    return cell;
}

@end
