//
//  DDTaskViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 04/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDTaskViewController.h"
#import "DDCategoryMiniatureCollectionViewCell.h"
#import "DDCustomCategoryCell.h"
#import "Categories.h"
#import "Task.h"

@interface DDTaskViewController ()

@end

@implementation DDTaskViewController

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
    [self.viewCategoriesMiniature setBackgroundColor:COULEUR_WHITE];
    [self.viewCategoriesMiniature.layer setCornerRadius:10.0];
    [self.viewCategoriesMiniature.layer setMasksToBounds:YES];
    [self.viewBackgroundTachesAction setBackgroundColor:COULEUR_BLACK];
    [self.viewBackgroundTachesAction.layer setCornerRadius:10.0];

    //On s'abonne a un type de cellule pour la table view et la collectionView
    [self.collectionViewMiniature registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CellCollectionView"];
    [self.tableViewCategorie registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellTableView"];
    
    //On récupère les catégories
    _arrayCategories = [NSMutableArray arrayWithArray:[[DDDatabaseAccess instance] getCategories]];
    [self setCurrentCategorie:[self.arrayCategories objectAtIndex:0]];

    //On configure le header et le texte de la tableView
    [self.viewBackgroundTableView.layer setCornerRadius:10.0];
    [self.viewBackgroundTableView.layer setMasksToBounds:YES];
    
    [self.labelCategory setFont:POLICE_HEADER];
    [self.labelCategory setTextColor:COULEUR_WHITE];
    
    //On met à jour les composants
    [self updateComponent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Controller fonctions


//On met à jour les composents
- (void)updateComponent
{
    //On récupère le dictionnaire des couleurs des catégories
    NSDictionary *dictColor = [[DDManagerSingleton instance] dictColor];
    [self.imageViewHeader setBackgroundColor:[dictColor objectForKey:self.currentCategorie.name]];
    [self.labelCategory setText:self.currentCategorie.name];
    [self.tableViewCategorie reloadData];
}


#pragma mark - UICollectionViewDelegate functions

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [self.arrayCategories count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //On récupère le dictionnaire des couleurs des catégories
    NSDictionary *dictColor = [[DDManagerSingleton instance] dictColor];
    
    //On récupère la cellule
    DDCategoryMiniatureCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CategoryMiniatureCell" forIndexPath:indexPath];
    
    //On récupère la categorie
    Categories *categorie = [self.arrayCategories objectAtIndex:indexPath.row];
    
    //On configure l'image du joueur
    [cell.imageViewCategory.layer setCornerRadius:10.0];
    [cell.imageViewCategory.layer setMasksToBounds:YES];
    [cell.imageViewCategory setBackgroundColor:[dictColor objectForKey:categorie.name]];
    
    //On configure le label du nom de la catégorie
    [cell.labelName setTextColor:COULEUR_WHITE];
    [cell.labelName setFont:POLICE_CATEGORY_MINIATURE];
    [cell.labelName setText:categorie.name];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //On récupère la categorie
    Categories *categorie = [self.arrayCategories objectAtIndex:indexPath.row];
    [self setCurrentCategorie:categorie];
    
    //On met à jour les composants
    [self updateComponent];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark Delegate Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.currentCategorie task] allObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //On récupère la cellule
    DDCustomCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCategoryCell" forIndexPath:indexPath];

    //On désactive le grisement de la sélection
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //On récupère un tableau des taches de la catégorie sélectionnée
    NSMutableArray *taskArray = [[DDDatabaseAccess instance] getTasksForCategory:self.currentCategorie];
    
    //On récupère le dictionnaire des couleurs des catégories
    NSDictionary *dictColor = [[DDManagerSingleton instance] dictColor];
    
    //On crée la tache que l'on va afficher dans les cellules
    Task *task = nil;
    
    //Si on a une tache
    if ([taskArray count] > 0)
        task = [taskArray objectAtIndex:indexPath.row];
    
    //On configure les infos de la cellule
    [cell.imageViewBackground setBackgroundColor:[dictColor objectForKey:self.currentCategorie.name]];
    
    [cell.labelNomTask setTextColor:COULEUR_BLACK];

    [cell.labelNomTask setText:task.name];
    
    [cell.labelPoint setTextColor:COULEUR_BLACK];

    [cell.labelPoint setText:[NSString stringWithFormat:@"%i points", [task.point integerValue]]];
    
    return cell;
}

//On ouvre la cellule sélectionné
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([self.tableTask isEditing] == false)
//    {
//        //On récupère la tache sélectionnée
//        NSMutableArray *taskArray =  [[self.taskController getTaskInCategory:self.category] retain];
//        Task *task = [taskArray objectAtIndex:indexPath.row];
//        
//        //On rafraichis les infos
//        [self refreshInfosAndObjectifWithTask:task];
//        
//        //On release le tableau
//        [taskArray release];
//    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        //On récupère la tache sélectionnée
//        NSMutableArray *taskArray = [[self.taskController getTaskInCategory:self.category] retain];
//        Task *task = [taskArray objectAtIndex:indexPath.row];
//        
//        [self.playerController deleteEventForTask:task];
//        [self.playerController deleteTropheesInTask:task];
//        [self.taskController deleteTask:task];
//        
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        
//        //On rafraichi les données
//        [self refreshAllData];
//        
//        [taskArray release];
//    }
}

//Empêche la suppression en mode sélection
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

@end
