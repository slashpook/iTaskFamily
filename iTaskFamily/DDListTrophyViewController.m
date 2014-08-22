//
//  DDListTrophyViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 15/08/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDListTrophyViewController.h"
#import "DDTrophyCell.h"
#import "DDCustomProgressBar.h"

@interface DDListTrophyViewController ()

@end

@implementation DDListTrophyViewController

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
    
    [self.tableViewTrophy registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellTableView"];
}


#pragma mark - Fonctions du controller

//On met à jour la vue
- (void)updateComponent
{
    //On affiche le nom du trophée
    [self.labelLibelleTrophy setText:self.trophy.libelle];

    int numberOfTrophyRealized = [[DDDatabaseAccess instance] getNumberOfTrophyAchievedForPlayer:[[DDManagerSingleton instance] currentPlayer] inCategory:self.category andType:self.trophy.type];
    [self.labelRealisationTrophy setText:[NSString stringWithFormat:@"%i/%i", numberOfTrophyRealized, (int)[[[DDDatabaseAccess instance] getTasksForCategory:self.category] count]]];
    
    //Suivant le type de trophée, on affiche l'image qui lui correspond
    if ([self.trophy.type isEqualToString:@"Bronze"])
       [self.imageViewTrophy setImage:[UIImage imageNamed:@"TrophyManager3"]];
    else if ([self.trophy.type isEqualToString:@"Argent"])
        [self.imageViewTrophy setImage:[UIImage imageNamed:@"TrophyManager2"]];
    else
        [self.imageViewTrophy setImage:[UIImage imageNamed:@"TrophyManager1"]];
    
    [self.tableViewTrophy reloadData];
}


#pragma mark - TableView Delegate fonctions

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.category tasks] allObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //On récupère la cellule
    DDTrophyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrophyCell" forIndexPath:indexPath];
    
    //On récupère le joueur courant
    Player *currentPlayer = [[DDManagerSingleton instance] currentPlayer];
    
    //On récupère un tableau des taches de la catégorie sélectionnée
    Task *task = [[NSMutableArray arrayWithArray:[[DDDatabaseAccess instance] getTasksForCategory:self.category]] objectAtIndex:indexPath.row];
    NSArray *arrayTrophy = [[DDDatabaseAccess instance] getTrophiesSortedInArray:[task.trophies allObjects]];
    
    //On récupère le dictionnaire des couleurs des catégories
    NSDictionary *dictColor = [[DDManagerSingleton instance] dictColor];

    //On récupère le nombre de fois que le player a réalisé la task
    int numberOfEventChecked = 0;
    if (currentPlayer != nil)
        numberOfEventChecked = [[DDDatabaseAccess instance] getNumberOfEventCheckedForPlayer:currentPlayer forTask:task];
    
    //On récupère les trophies de la task
    Trophy *trophyTask;
    if ([self.trophy.type isEqualToString:@"Bronze"])
        trophyTask = [arrayTrophy objectAtIndex:0];
    else if ([self.trophy.type isEqualToString:@"Argent"])
        trophyTask = [arrayTrophy objectAtIndex:1];
    else
        trophyTask = [arrayTrophy objectAtIndex:2];
    
    //On rempli les infos sur les points et le nom de la tache
    [cell.labelName setText:task.libelle];
    
    //On set les progressBar
    [cell.progressBar setBackgroundColor:[UIColor clearColor]];
    [cell.progressBar setColorBackground:COULEUR_BLACK];
    [cell.progressBar setTrophy:trophyTask];
    [cell.progressBar setPlayer:currentPlayer];
    [cell.progressBar setColorRealisation:[dictColor objectForKey:self.category.libelle]];
    [cell.labelOccurenceRealised setText:[NSString stringWithFormat:@"%i", (numberOfEventChecked > trophyTask.iteration.intValue) ? trophyTask.iteration.intValue : numberOfEventChecked]];
    [cell.labelTotalOccurence setText:[NSString stringWithFormat:@"%i", trophyTask.iteration.intValue]];
    [cell.progressBar setNeedsDisplay];
    return cell;
}

@end
