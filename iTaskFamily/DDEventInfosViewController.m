//
//  DDEventInfosViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 02/03/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDEventInfosViewController.h"
#import "DDCustomEventCell.h"
#import "Player.h"
#import "Event.h"
#import "Categories.h"
#import "Task.h"

@interface DDEventInfosViewController ()

@end

@implementation DDEventInfosViewController


#pragma mark - Fonctions de base

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _arrayEvent = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.view setBackgroundColor:COULEUR_WHITE];
    
    //On configure l'arrondi des vues et composants
    [self.textViewComment.layer setCornerRadius:10.0];
    [self.textViewComment.layer setBorderWidth:1.0];
    [self.textViewComment.layer setBorderColor:COULEUR_BACKGROUND.CGColor];
    [self.imageViewCategory.layer setCornerRadius:10.0];
    [self.imageViewPoints.layer setCornerRadius:10.0];
    [self.imageViewRepetition.layer setCornerRadius:10.0];
    
    //On set la police et la couleur des label et textfield
    
    //On configure la tableView
    [self.tableViewEvents registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellTableView"];

    
    //On met à jour les composants
    [self updateComponent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Controllers functions

//On met à jour les composants
- (void)updateComponent
{
    [self.tableViewEvents reloadData];
    
    //On récupère le dictionnaire des couleurs des catégories
    NSDictionary *dictColor = [[DDManagerSingleton instance] dictColor];
    [self.imageViewCategory setBackgroundColor:[dictColor objectForKey:self.currentEvent.task.categories.name]];
    [self.labelCategory setText:self.currentEvent.task.categories.name];
    [self.imageViewPoints setBackgroundColor:[dictColor objectForKey:self.currentEvent.task.categories.name]];
    [self.labelPoint setText:self.currentEvent.task.point.stringValue];
    [self.imageViewRepetition setBackgroundColor:[dictColor objectForKey:self.currentEvent.task.categories.name]];
    
    [self.textViewComment setText:self.currentEvent.comment];
}

//On set le tableau d'event pour le jour sélectionné
- (void)getEventsForDay:(NSString *)currentDay
{
    //On récupère le tableau des évènements du joueur en cours
    Player *currentPlayer = [[DDManagerSingleton instance] currentPlayer];
    [self setArrayEvent:[[DDDatabaseAccess instance] getEventsForPlayer:currentPlayer atDay:currentDay]];
    
    [self updateComponent];
}


#pragma mark Delegate Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayEvent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //On récupère la cellule
    DDCustomEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomEventCell" forIndexPath:indexPath];
    
    //On récupère le dictionnaire des couleurs des catégories
    NSDictionary *dictColor = [[DDManagerSingleton instance] dictColor];
    
    //On récupère l'event que l'on va afficher dans la cellule
    Event *event = [self.arrayEvent objectAtIndex:indexPath.row];
    
    //On configure les infos de la cellule
    [cell.imageViewCategoryColor setBackgroundColor:[dictColor objectForKey:event.task.categories.name]];
    [cell.labelTask setTextColor:COULEUR_BLACK];
    [cell.labelTask setFont:POLICE_EVENT_TASK_NAME];
    [cell.labelTask setText:event.task.name];
    [cell.labelInfo setTextColor:COULEUR_BLACK];
    [cell.labelInfo setFont:POLICE_EVENT_TASK_INFO];
    [cell.labelInfo setText:[NSString stringWithFormat:@"%@ : %i points", event.task.categories.name, [event.task.point intValue]]];
    [cell.imageViewSeparation setBackgroundColor:COULEUR_BACKGROUND];
    
    //On change la couleur de la cellule suivant si c'est la cellule sélecitonné ou non
    if ([event.task.name isEqualToString:self.currentEvent.task.name])
        [[cell contentView] setBackgroundColor:COULEUR_CELL_SELECTED];
    else
        [[cell contentView] setBackgroundColor:COULEUR_WHITE];
    
    return cell;
}

//On ouvre la cellule sélectionné
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableViewEvents isEditing] == false)
    {
        [self setCurrentEvent:[self.arrayEvent objectAtIndex:indexPath.row]];
        
        //On met à jour les composants
        [self updateComponent];
    }
}

//Suppression de la tache sélectionnée
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Event *event = [self.arrayEvent objectAtIndex:indexPath.row];
        
        //On supprime la tache
        [[DDDatabaseAccess instance] deleteEvent:event];
        
        //On recher la tableView
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //On rafraichi les données
        [self updateComponent];
    }
}

//Empêche la suppression en mode sélection
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

@end
