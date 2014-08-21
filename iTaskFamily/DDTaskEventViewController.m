//
//  DDTaskEventViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 21/02/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDTaskEventViewController.h"
#import "DDCustomCategoryListCell.h"

@interface DDTaskEventViewController ()

@end

@implementation DDTaskEventViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _arrayTasks = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    //On set le background de la vue
    [[self view] setBackgroundColor:COULEUR_BACKGROUND];
    
    //On met en place la barre de navigation
    _custoNavBar = [[DDCustomNavigationBarController alloc] initWithDelegate:self andTitle:@"" andBackgroundColor:[DDHelperController getMainTheme] andImage:[UIImage imageNamed:@"TaskButtonNavigationBarAdd"]];
    [[self.custoNavBar view] setFrame:CGRectMake(0, 0, 380, 50)];
    [[self.custoNavBar buttonRight] setHidden:YES];
    [[self.custoNavBar buttonLeft] setTitle:@"Retour" forState:UIControlStateNormal];
    [self.view addSubview:self.custoNavBar.view];
    
    //On s'abonne a un type de cellule pour la table view
    [self.tableViewTask registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TaskCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Controller fonctions

//On rempli la database avec les taches de la catégorie correspondante
- (void)setDatabaseForCategory:(NSString *)categoryName
{
    if ([categoryName isEqualToString:PLUS_UTILISE])
        [self setArrayTasks:[NSMutableArray arrayWithArray:[[DDDatabaseAccess instance] getArrayHistoriqueTask]]];
    //Si on est sur une catégorie, on la récupère pour récupérer les taches
    else
    {
        CategoryTask *category = [[DDDatabaseAccess instance] getCategoryTaskWithLibelle:categoryName];
        [self setArrayTasks:[NSMutableArray arrayWithArray:[[DDDatabaseAccess instance] getTasksForCategory:category]]];
    }
}


#pragma mark Delegate Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayTasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //On récupère la cellule
    DDCustomCategoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCategoryListCell" forIndexPath:indexPath];
   
    //On récupère le dictionnaire des couleurs
    NSDictionary *dictColor = [[DDManagerSingleton instance] dictColor];
    
    //On récupère la tache pour l'indexPath donné
    Task *task = [self.arrayTasks objectAtIndex:indexPath.row];
    
    //On configure les infos de la cellule
    [cell.imageViewCategoryColor setBackgroundColor:[dictColor objectForKey:task.category.libelle]];
    [cell.labelNameCategory setTextColor:COULEUR_BLACK];
    [cell.labelNameCategory setText:task.libelle];
    [cell.labelNameCategory setFont:POLICE_TASK_CELL];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //On récupère la tache pour l'indexPath donné
    Task *task = [self.arrayTasks objectAtIndex:indexPath.row];
    
    //On appelle le delegate pour renvoyer la donnée à la vue event
    [self.delegate saveTaskWithTask:task];
    
    [self.navigationController popToRootViewControllerAnimated:true];
}


#pragma mark CustoNavigationBar fonctions

//On appuie sur le bouton de retour
-(void)onPushLeftBarButton
{
    [self.navigationController popViewControllerAnimated:true];
}

@end
