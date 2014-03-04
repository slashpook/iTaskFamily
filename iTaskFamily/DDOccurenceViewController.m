//
//  DDOccurenceViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 20/02/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDOccurenceViewController.h"
#import "DDCustomOccurenceCell.h"

@interface DDOccurenceViewController ()

@end

@implementation DDOccurenceViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _arrayIndexPath = [[NSMutableArray alloc] init];
        _arrayOccurenceSaved = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //On met en place la barre de navigation
    _custoNavBar = [[DDCustomNavigationBarController alloc] initWithDelegate:self andTitle:@"" andBackgroundColor:COULEUR_HOME andImage:[UIImage imageNamed:@"TaskButtonNavigationBarAdd"]];
    [[self.custoNavBar view] setFrame:CGRectMake(0, 0, 380, 50)];
    [[self.custoNavBar buttonRight] setTitle:@"Sauver" forState:UIControlStateNormal];
    [[self.custoNavBar buttonLeft] setTitle:@"Retour" forState:UIControlStateNormal];
    [self.view addSubview:self.custoNavBar.view];
    
    //On s'enregistre sur la classe de la cellule
    [self.tableViewOccurence registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    //On met à jour les composants
    [self updateComponents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Controller fonctions

//On met à jour les composants
- (void)updateComponents
{
    //On change le type de sélection si on est en modification
    if (self.isModifyEvent == true)
        [self.tableViewOccurence setMultipleTouchEnabled:false];
    else
        [self.tableViewOccurence setMultipleTouchEnabled:true];
    
    //On met à jour le tableau d'indexPath sélectionné
    [self.arrayIndexPath removeAllObjects];
    for (NSString *day in self.arrayOccurenceSaved)
    {
        int row = [[[DDManagerSingleton instance] arrayWeek] indexOfObject:day];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self.arrayIndexPath addObject:indexPath];
    }
    
    //On recharge la liste pour mettre à jour les dates sélectionnées
    [[self tableViewOccurence] reloadData];
}


#pragma mark Delegate Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[DDManagerSingleton instance] arrayWeek] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //On récupère la cellule
    DDCustomOccurenceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OccurenceCell" forIndexPath:indexPath];
    
    //On configure la cellule
    [[cell textLabel] setFont:POLICE_EVENT_CELL];
    [[cell textLabel] setTextColor:COULEUR_BLACK];
    [[cell textLabel] setText:[[[DDManagerSingleton instance] arrayWeek] objectAtIndex:indexPath.row]];
    [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
    
    //On met ou non le checkmark sur les cellules en fonctions de celle qui ont été sélectionné
    if ([self.arrayIndexPath containsObject:indexPath])
    {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else
    {
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    //On cache la séparation pour la dernière cellule (pas nécessaire)
    if (indexPath.row == [[[DDManagerSingleton instance] arrayWeek] count] - 1)
        [[cell viewSeparator] setHidden:YES];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //On crée un tableau temporaire pour recharger les cellules à modifier
    NSMutableArray *arrayIndexPathTemp = [NSMutableArray array];
    
    //Si on est en modification d'évènement, on ne rempli le tableau qu'avec une donnée
    if (self.isModifyEvent == true)
    {
        //Si on est pas sur le même jour que celui sélectionné, on vide le tableau et on rajoute le nouveau jour
        if ([self.arrayIndexPath containsObject:indexPath] == false)
        {
            [arrayIndexPathTemp addObjectsFromArray:self.arrayIndexPath];
            [arrayIndexPathTemp addObject:indexPath];
            
            
            [self.arrayIndexPath removeAllObjects];
            [self.arrayIndexPath addObject:indexPath];
            
            //On recharge les cellules
            [tableView reloadRowsAtIndexPaths:arrayIndexPathTemp withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else
    {
        //Si on déselectionne une cellule
        if ([self.arrayIndexPath containsObject:indexPath])
            [self.arrayIndexPath removeObject:indexPath];
        //Sinon si on sélectionne
        else
        {
            //On ajoute l'index path à notre tableau
            [self.arrayIndexPath addObject:indexPath];
        }
        
        //On rajoute l'index path au tableau qui contient les cellules à recharger
        [arrayIndexPathTemp addObject:indexPath];
        
        //On recharge les cellules
        [tableView reloadRowsAtIndexPaths:arrayIndexPathTemp withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


#pragma mark - NavigationBar fonctions

//On appuie sur le bouton de gauche
- (void)onPushLeftBarButton
{
    //On revient vers la page d'event
    [self.navigationController popToRootViewControllerAnimated:true];
}

//On appuie sue le bouton de droite
- (void)onPushRightBarButton
{
    //On vide le tableau d'occurence sauvegardées
    [self.arrayOccurenceSaved removeAllObjects];
    
    //On trie le tableau d'indexPath
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"row" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sorter];
    [self.arrayIndexPath sortUsingDescriptors:sortDescriptors];

    //On rempli le tableau avec les jours sélectionnés
    for (NSIndexPath *indexPath in self.arrayIndexPath)
        [self.arrayOccurenceSaved addObject:[[[DDManagerSingleton instance] arrayWeek] objectAtIndex:indexPath.row]];
    
    //On appelle le delegate pour mettre la vue d'event à jour
    [self.delegate saveOccurencewithArray:self.arrayOccurenceSaved];
    
    //On revient vers la page d'event
    [self.navigationController popToRootViewControllerAnimated:true];
}

@end
