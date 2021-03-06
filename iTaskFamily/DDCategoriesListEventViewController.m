//
//  DDCategoriesListEventViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 21/02/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDCategoriesListEventViewController.h"
#import "DDCustomCategoryListCell.h"

@interface DDCategoriesListEventViewController ()

@end

@implementation DDCategoriesListEventViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _arrayCategory = [[NSMutableArray alloc] init];
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
    [[self.custoNavBar buttonLeft] setTitle:NSLocalizedString(@"RETOUR", nil) forState:UIControlStateNormal];
    [self.view addSubview:self.custoNavBar.view];
    
    //On rempli le tableau avec les catégories
    [self.arrayCategory addObject:NSLocalizedString(@"PLUS_UTILISE", nil)];
    for (CategoryTask *category in [[DDDatabaseAccess instance] getCategoryTasks])
        [self.arrayCategory addObject:NSLocalizedString([category.libelle uppercaseString], nil)];
    
    //On s'abonne a un type de cellule pour la table view
    [self.tableViewCategorie registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CategorieTaskCell"];
    
    [[self tableViewCategorie] setBackgroundColor:COULEUR_WHITE];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableViewCategorie reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Delegate Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayCategory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //On récupère la cellule
    DDCustomCategoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCategoryListCell" forIndexPath:indexPath];
    
    //On récupère le dictionnaire des couleurs
    NSDictionary *dictColor = [[DDManagerSingleton instance] dictColor];
    
    //On récupère la catégorie en cours
    NSString *categorie = [self.arrayCategory objectAtIndex:indexPath.row];
    NSString *categorieColor;
    
    if (indexPath.row > 0)
        categorieColor = [[[[DDDatabaseAccess instance] getCategoryTasks] objectAtIndex:(indexPath.row - 1)] libelle];
    else
        categorieColor = NSLocalizedString(@"PLUS_UTILISE", nil);
    
    //On configure les infos de la cellule
    [cell.imageViewCategoryColor setBackgroundColor:[dictColor objectForKey:categorieColor]];
    [cell.labelNameCategory setTextColor:COULEUR_BLACK];
    [cell.labelNameCategory setText:categorie];
    [cell.labelNameCategory setFont:POLICE_TASK_CELL];
    
    return cell;
}

//On ouvre la cellule sélectionné
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //On récupère la catégorie en cours
    NSString *categorie;
    if (indexPath.row > 0)
        categorie = [[[[DDDatabaseAccess instance] getCategoryTasks] objectAtIndex:(indexPath.row - 1)] libelle];
    else
        categorie = NSLocalizedString(@"PLUS_UTILISE", nil);
    
    //On crée la vue des taches et on la push
    DDTaskEventViewController *taskEventViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"TaskEventViewController"];
    [taskEventViewController setDelegate:self.delegate];
    [taskEventViewController setDatabaseForCategory:categorie];
    [self.navigationController pushViewController:taskEventViewController animated:YES];
}


#pragma mark CustoNavigationBar fonctions

//On appuie sur le bouton de retour
-(void)onPushLeftBarButton
{
    [self.navigationController popViewControllerAnimated:true];
}

@end
