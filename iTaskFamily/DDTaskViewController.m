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
#import "DDCustomProgressBar.h"
#import "DDPopOverViewController.h"

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
    [self.viewBackgroundTachesAction setBackgroundColor:COULEUR_BLACK];
    [self.viewBackgroundTachesAction.layer setCornerRadius:10.0];
    
    //On s'abonne a un type de cellule pour la table view et la collectionView
    [self.collectionViewMiniature registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CellCollectionView"];
    [self.tableViewCategorie registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellTableView"];
    
    //On récupère les catégories
    _arrayCategories = [NSMutableArray arrayWithArray:[[DDDatabaseAccess instance] getCategoryTasks]];
    [self setCurrentCategorie:[self.arrayCategories objectAtIndex:0]];
    
    //On configure le header et le texte de la tableView
    [self.viewBackgroundTableView.layer setCornerRadius:10.0];
    [self.viewBackgroundTableView.layer setMasksToBounds:YES];
    [self.labelCategory setFont:POLICE_HEADER];
    [self.labelCategory setTextColor:COULEUR_WHITE];
    [self.imageViewHeaderTableView setBackgroundColor:COULEUR_BLACK];
    [self.labelNoTask setTextColor:COULEUR_BLACK];
    [self.labelNoTask setFont:POLICE_EVENT_NO_PLAYER];
    
    //On configure les composants de la section information
    [self.viewBackgroundInformation.layer setCornerRadius:10.0];
    [self.viewBackgroundInformation.layer setMasksToBounds:YES];
    [self.labelInformation setFont:POLICE_HEADER];
    [self.labelInformation setTextColor:COULEUR_WHITE];
    [self.imageViewHeaderInformation setBackgroundColor:COULEUR_BLACK];
    [self.imageViewBackgroundPoint.layer setCornerRadius:60.0];
    [self.labelObjectif setFont:POLICE_INFO_TROPHE];
    [self.labelObjectif setTextColor:COULEUR_BLACK];
    [self.labelInfoObjectif setFont:POLICE_INFO_TROPHE];
    [self.labelInfoObjectif setTextColor:COULEUR_BLACK];
    [self.labelNbrTrophy setFont:POLICE_INFO_TROPHE_REALISED];
    [self.labelNbrTrophy setTextColor:COULEUR_BLACK];
    [self.labelTaskName setTextColor:COULEUR_BLACK];
    [self.labelTaskName setFont:POLICE_CATEGORY_MINIATURE];
    [self.labelTaskName setMinimumScaleFactor:0.5];
    [self.labelTaskPoint setTextColor:COULEUR_WHITE];
    [self.labelTaskPoint setFont:POLICE_INFO_TACHE];
    [self.labelTaskPoint setMinimumScaleFactor:0.5];
    [self.imageViewPlayer.layer setCornerRadius:60.0];
    [self.imageViewPlayer.layer setMasksToBounds:YES];
    [self.progressBarBronze setBackgroundColor:[UIColor clearColor]];
    [self.progressBarBronze setColorBackground:COULEUR_BLACK];
    [self.progressBarArgent setBackgroundColor:[UIColor clearColor]];
    [self.progressBarArgent setColorBackground:COULEUR_BLACK];
    [self.progressBarOr setBackgroundColor:[UIColor clearColor]];
    [self.progressBarOr setColorBackground:COULEUR_BLACK];
    
    //On initialise le popOver, le navigation controller et le playerManagerViewController
    _popOverViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"PopOverViewController"];
    _taskManagerViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"TaskManagerViewController"];
    [self.taskManagerViewController setDelegate:self];
    _navigationTaskManagerViewController = [[UINavigationController alloc] initWithRootViewController:self.taskManagerViewController];
    
    //On met à jour les composants
    [self updateComponent];
    
    //On met en place la notification pour modifier le joueur
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateComponent)
                                                 name:UPDATE_PLAYER
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self setArrayCategories:[NSMutableArray arrayWithArray:[[DDDatabaseAccess instance] getCategoryTasks]]];
}


#pragma mark - Controller fonctions


//On met à jour les composents
- (void)updateComponent
{
    //On set le joueur sélectionné
    [self setCurrentPlayer:[[DDManagerSingleton instance] currentPlayer]];
    
    //On récupère le dictionnaire des couleurs des catégories
    [self.labelCategory setText:self.currentCategorie.libelle];
    
    //On récupère le tableau de tache
    NSMutableArray *arrayTask = [NSMutableArray arrayWithArray:[[DDDatabaseAccess instance] getTasksForCategory:self.currentCategorie]];
    
    //On rafraichis les données si on est sur une catégorie valide
    if ([arrayTask count] > 0)
    {
        //Si la tache courante est nulle (on vient de changer de catégorie
        if (self.currentTask == nil)
            [self setCurrentTask:[arrayTask objectAtIndex:0]];
    }
    else
        [self setCurrentTask:nil];
    
    //On rafraichis les données de la tache et la tableView
    [self refreshInformationSection];
    [self.tableViewCategorie reloadData];
}

//On rafrachis les données de la tache sélectionné
- (void)refreshInformationSection
{
    //On récupère le dictionnaire des couleurs des catégories
    NSDictionary *dictColor = [[DDManagerSingleton instance] dictColor];
    
    //Si on a une tache
    if (self.currentTask != nil)
    {
        //On récupère le nombre total de trophées pour la catégorie donnée
        int numberTotalTrophy = (int)[[[DDDatabaseAccess instance] getTasksForCategory:self.currentCategorie] count] * 3;
        int numberTotalTrophyRealised = 0;
        
        //Si le joueur existe on récupère le nombre de trophées qu'il a réalisé
        if (self.currentPlayer != nil)
        {
            numberTotalTrophyRealised = [[DDDatabaseAccess instance] getNumberOfTrophyAchievedForPlayer:self.currentPlayer inCategory:self.currentCategorie];
        }
        
        //On set le nombre de trophées remporté
        [self.labelNbrTrophy setText:[NSString stringWithFormat:@"%i/%i", numberTotalTrophyRealised ,numberTotalTrophy]];
        
        NSArray *arrayTrophy = [[DDDatabaseAccess instance] getTrophiesSortedInArray:[self.currentTask.trophies allObjects]];
        
        //On récupère le nombre de fois que le player a réalisé la task
        int numberOfEventChecked = [[DDDatabaseAccess instance] getNumberOfEventCheckedForPlayer:self.currentPlayer forTask:self.currentTask];
        
        //On récupère les trophies de la task
        Trophy *trophyBronze = [arrayTrophy objectAtIndex:0];
        Trophy *trophyArgent = [arrayTrophy objectAtIndex:1];
        Trophy *trophyOr = [arrayTrophy objectAtIndex:2];
        
        //On rempli les infos sur les points et le nom de la tache
        [self.labelTaskName setText:self.currentTask.libelle];
        [self.labelTaskPoint setText:[NSString stringWithFormat:@"%@\npoints", [self.currentTask.point stringValue]]];
        [self.labelNoTask setHidden:YES];
        
        //On set les progressBar
        [self.progressBarBronze setTrophy:trophyBronze];
        [self.progressBarBronze setPlayer:self.currentPlayer];
        [self.progressBarBronze setColorRealisation:[dictColor objectForKey:self.currentCategorie.libelle]];
        [self.labelRealizedBronze setText:[NSString stringWithFormat:@"%i", (numberOfEventChecked > trophyBronze.iteration.intValue) ? trophyBronze.iteration.intValue : numberOfEventChecked]];
        [self.labelTotalBronze setText:[NSString stringWithFormat:@"%i", trophyBronze.iteration.intValue]];
        [self.progressBarArgent setTrophy:trophyArgent];
        [self.progressBarArgent setPlayer:self.currentPlayer];
        [self.progressBarArgent setColorRealisation:[dictColor objectForKey:self.currentCategorie.libelle]];
        [self.labelRealizedArgent setText:[NSString stringWithFormat:@"%i", (numberOfEventChecked > trophyArgent.iteration.intValue) ? trophyArgent.iteration.intValue : numberOfEventChecked]];
        [self.labelTotalArgent setText:[NSString stringWithFormat:@"%i", trophyArgent.iteration.intValue]];
        [self.progressBarOr setTrophy:trophyOr];
        [self.progressBarOr setPlayer:self.currentPlayer];
        [self.progressBarOr setColorRealisation:[dictColor objectForKey:self.currentCategorie.libelle]];
        [self.labelRealizedOr setText:[NSString stringWithFormat:@"%i", (numberOfEventChecked > trophyOr.iteration.intValue) ? trophyOr.iteration.intValue : numberOfEventChecked]];
        [self.labelTotalOr setText:[NSString stringWithFormat:@"%i", trophyOr.iteration.intValue]];
    }
    else
    {
        [self.labelTaskName setText:@"Aucune tache"];
        [self.labelTaskPoint setText:@"0\npoint"];
        [self.labelNoTask setHidden:NO];
        
        //On set les progress bar
        [self.progressBarBronze setTrophy:nil];
        [self.progressBarBronze setPlayer:nil];
        [self.labelRealizedBronze setText:@"0"];
        [self.labelTotalBronze setText:@"0"];
        [self.progressBarArgent setTrophy:nil];
        [self.progressBarArgent setPlayer:nil];
        [self.labelRealizedArgent setText:@"0"];
        [self.labelTotalArgent setText:@"0"];
        [self.progressBarOr setTrophy:nil];
        [self.progressBarOr setPlayer:nil];
        [self.labelRealizedOr setText:@"0"];
        [self.labelTotalOr setText:@"0"];
        [self.labelNbrTrophy setText:@"0/0"];
    }
    
    //On met à jour le fond des points
    [self.imageViewBackgroundPoint setBackgroundColor:[dictColor objectForKey:self.currentCategorie.libelle]];
    
    //On met à jour l'imageView du joueur
    if (self.currentPlayer != nil)
    {
        [self.imageViewPlayer setImage:[[[DDManagerSingleton instance] dictImagePlayer] objectForKey:self.currentPlayer.pseudo]];
    }
    else
    {
        [self.imageViewPlayer setImage:[UIImage imageNamed:@"PlayerManageProfil"]];
    }
    
    //On rafraichis les progressbar
    [self.progressBarBronze setNeedsDisplay];
    [self.progressBarArgent setNeedsDisplay];
    [self.progressBarOr setNeedsDisplay];
}

//On ouvre le taskManager pour ajouter une tache
- (IBAction)onPushAddTask:(id)sender
{
    //On configure le controller
    [self.taskManagerViewController setIsModifyTask:NO];
    [self.taskManagerViewController setTask:nil];
    [self.taskManagerViewController updateComponent];
    
    //On ouvre la popUp
    [self openTaskManagerViewController];
}

//On supprime les taches
- (IBAction)onPushRemoveTask:(id)sender
{
    //On lance l'animation d'édition
    if ([self.tableViewCategorie isEditing] == true)
        [self.tableViewCategorie setEditing:false animated:true];
    else
        [self.tableViewCategorie setEditing:true animated:true];
}

//On ouvre le taskManger pour modifier une tache
- (IBAction)onPushEditTask:(id)sender
{
    //On configure le controller
    [self.taskManagerViewController setIsModifyTask:YES];
    [self.taskManagerViewController setTask:self.currentTask];
    [self.taskManagerViewController updateComponent];
    
    //On ouvre la popUp
    [self openTaskManagerViewController];
}

//On ouvre la popUp
- (void)openTaskManagerViewController
{
    //On set la catégorie en cours pour le task manager
    [self.taskManagerViewController setCurrentCategory:self.currentCategorie];
    
    //On pop le navigation controller
    [self.navigationTaskManagerViewController popToRootViewControllerAnimated:NO];
    
    [[[[[[UIApplication sharedApplication] delegate] window] rootViewController] view] addSubview:self.popOverViewController.view];
    
    //On présente la popUp
    CGRect frame = self.taskManagerViewController.view.frame;
    [self.popOverViewController presentPopOverWithContentView:self.navigationTaskManagerViewController.view andSize:frame.size andOffset:CGPointMake(0, 0)];
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
    
    //On récupère la category
    CategoryTask *category = [self.arrayCategories objectAtIndex:indexPath.row];
    
    //On configure l'image du joueur
    [cell.imageViewCategory.layer setCornerRadius:10.0];
    [cell.imageViewCategory setBackgroundColor:[dictColor objectForKey:category.libelle]];
    
    //On configure le label du nom de la catégorie
    [cell.labelName setTextColor:COULEUR_WHITE];
    [cell.labelName setFont:POLICE_CATEGORY_MINIATURE];
    [cell.labelName setText:category.libelle];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //On récupère la categorie
    CategoryTask *category = [self.arrayCategories objectAtIndex:indexPath.row];
    [self setCurrentCategorie:category];
    [self setCurrentTask:nil];
    
    //On met à jour les composants
    [self updateComponent];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


#pragma mark Delegate Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.currentCategorie tasks] allObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //On récupère la cellule
    DDCustomCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCategoryCell" forIndexPath:indexPath];
    
    //On récupère un tableau des taches de la catégorie sélectionnée
    NSMutableArray *taskArray = [NSMutableArray arrayWithArray:[[DDDatabaseAccess instance] getTasksForCategory:self.currentCategorie]];
    
    //On récupère le dictionnaire des couleurs des catégories
    NSDictionary *dictColor = [[DDManagerSingleton instance] dictColor];
    
    //On crée la tache que l'on va afficher dans les cellules
    Task *task = nil;
    
    //Si on a une tache
    if ([taskArray count] > 0)
        task = [taskArray objectAtIndex:indexPath.row];
    
    //On configure les infos de la cellule
    [cell.imageViewBackground setBackgroundColor:[dictColor objectForKey:self.currentCategorie.libelle]];
    [cell.labelNomTask setTextColor:COULEUR_BLACK];
    [cell.labelNomTask setText:task.libelle];
    [cell.labelPoint setTextColor:COULEUR_BLACK];
    [cell.labelPoint setText:[NSString stringWithFormat:@"%i points", [task.point intValue]]];
    
    //On change la couleur de la cellule suivant si c'est la cellule sélecitonné ou non
    if ([task.libelle isEqualToString:self.currentTask.libelle])
        [[cell contentView] setBackgroundColor:COULEUR_CELL_SELECTED];
    else
        [[cell contentView] setBackgroundColor:COULEUR_WHITE];
    
    return cell;
}

//On ouvre la cellule sélectionné
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableViewCategorie isEditing] == false)
    {
        //On récupère le tableau de tache et on met à jour la tache courante
        NSArray *arrayTask = [[DDDatabaseAccess instance] getTasksForCategory:self.currentCategorie];
        [self setCurrentTask:[arrayTask objectAtIndex:indexPath.row]];
        
        //On met à jour les composants
        [self updateComponent];
    }
}

//Suppression de la tache sélectionnée
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [DDCustomAlertView displayAnswerMessage:@"Voulez vous supprimer cette tache ? Cela entrainera la suppression des évènements qui lui sont liés"  withDelegate:self andSetTag:(int)indexPath.row];
    }
}

//Pour pouvoir swiper pour supprimer
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark - DDTaskManagerViewController Functions

- (void)closeTaskManagerView
{
    //On met à jour les composants
    [self updateComponent];
    
    //On enlève la popUp
    [self.popOverViewController hide];
}


#pragma mark - UIAlertViewProtocol delegate functions

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //On annule pas l'event
    if (buttonIndex == 0)
    {
        //On récupère la tache sélectionnée
        NSArray *arrayTask = [[DDDatabaseAccess instance] getTasksForCategory:self.currentCategorie];
        Task *task = [arrayTask objectAtIndex:alertView.tag];
        self.currentTask = nil;
        
        //On supprime la tache
        [[DDDatabaseAccess instance] deleteTask:task];
        
        //On recharge la tableView
        [self.tableViewCategorie deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:alertView.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
        //On rafraichi les données
        [self updateComponent];
    }
}

@end
