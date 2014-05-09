//
//  DDCategorieListViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 06/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDCategorieListViewController.h"
#import "DDCustomCategoryListCell.h"

@interface DDCategorieListViewController ()

@end

@implementation DDCategorieListViewController

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

    //On met en place la barre de navigation
    _custoNavBar = [[DDCustomNavigationBarController alloc] initWithDelegate:self andTitle:@"" andBackgroundColor:COULEUR_HOME andImage:[UIImage imageNamed:@"TaskButtonNavigationBarAdd"]];
    [[self.custoNavBar view] setFrame:CGRectMake(0, 0, 380, 50)];
    [[self.custoNavBar buttonRight] setHidden:YES];
    [[self.custoNavBar buttonLeft] setTitle:@"Retour" forState:UIControlStateNormal];
    [self.view addSubview:self.custoNavBar.view];
    
    //On récupère le tableau des catégories
    [self setArrayCategory:[NSMutableArray arrayWithArray:[[DDDatabaseAccess instance] getCategoryTasks]]];
    
    //On s'abonne a un type de cellule pour la table view
    [self.tableViewCategory registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CategorieTaskCell"];
    [[self tableViewCategory] setBackgroundColor:COULEUR_WHITE];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableViewCategory reloadData];
    [[self.custoNavBar view] setBackgroundColor:self.couleurBackground];
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
    CategoryTask *category = [self.arrayCategory objectAtIndex:indexPath.row];
   
    //On configure les infos de la cellule
    [cell.imageViewCategoryColor setBackgroundColor:[dictColor objectForKey:category.libelle]];
    [cell.labelNameCategory setTextColor:COULEUR_BLACK];
    [cell.labelNameCategory setText:category.libelle];
    [cell.labelNameCategory setFont:POLICE_TASK_CELL];
    
    return cell;
}

//On ouvre la cellule sélectionné
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryTask *category = [self.arrayCategory objectAtIndex:indexPath.row];
    [self.delegate closeCategorieViewWithCategorie:category];
}


#pragma mark CustoNavigationBar fonctions

//On appuie sur le bouton de retour
-(void)onPushLeftBarButton
{
    [self.navigationController popViewControllerAnimated:true];
}

@end
