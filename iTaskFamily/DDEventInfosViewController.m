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
#import "DDCustomCheckbox.h"
#import "DDCustomValidation.h"

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
    [self.imageViewCategory.layer setCornerRadius:10.0];
    [self.imageViewPoints.layer setCornerRadius:10.0];
    [self.imageViewRepetition.layer setCornerRadius:10.0];
    
    //On set la police et la couleur des label et textfield
    [self.labelCategory setTextColor:COULEUR_WHITE];
    [self.labelPoint setTextColor:COULEUR_WHITE];
    [self.textViewComment setTextColor:COULEUR_BLACK];
    
    //On configure la tableView
    [self.tableViewEvents registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellTableView"];
    [self.tableViewEvents setDelegate:self];
    [self.tableViewEvents setDataSource:self];
    
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
    
    //On met à jour le nom de la tache
    [self.labelTask setText:self.currentEvent.task.name];
    
    //On affiche ou non le marqueur de validation
    if ([self.currentEvent.isFinished boolValue] == YES)
    {
        [self.viewCustomValidation setHidden:NO];
        [self.viewCustomValidation setColorValidation:[dictColor objectForKey:self.currentEvent.task.categories.name]];
        [self.viewCustomValidation setNeedsDisplay];
    }
    else
    {
        [self.viewCustomValidation setHidden:YES];
    }
    
    //On met à jour les 3 carrés de la vue info
    [self.imageViewCategory setBackgroundColor:[dictColor objectForKey:self.currentEvent.task.categories.name]];
    [self.labelCategory setText:self.currentEvent.task.categories.name];
    [self.imageViewPoints setBackgroundColor:[dictColor objectForKey:self.currentEvent.task.categories.name]];
    [self.labelPoint setText:self.currentEvent.task.point.stringValue];
    [self.imageViewRepetition setBackgroundColor:[dictColor objectForKey:self.currentEvent.task.categories.name]];
    if ([self.currentEvent.recurrence boolValue] == YES)
        [self.imageViewContentRepetition setAlpha:1.0];
    else
        [self.imageViewContentRepetition setAlpha:0.5];
    
    //On met à jour la textView de commentaire
    [self.textViewComment setBackgroundColor:COULEUR_CELL_SELECTED];
    if ([self.currentEvent.comment length] > 0)
        [self.textViewComment setText:self.currentEvent.comment];
    else
        [self.textViewComment setText:@"Aucun commentaire."];
}

//On sélectionne la première cellule
- (void)selectFirstRow
{
    //Si on a des event, on sélectionne la première cellule
    if ([self.arrayEvent count] > 0 && self.currentEvent == nil)
    {
        [self setCurrentEvent:[self.arrayEvent objectAtIndex:0]];
    }
}

//On set le tableau d'event pour le jour sélectionné
- (void)getEventsForDay:(NSString *)currentDay
{
    //On récupère le tableau des évènements du joueur en cours
    Player *currentPlayer = [[DDManagerSingleton instance] currentPlayer];
    [self setArrayEvent:[[DDDatabaseAccess instance] getEventsForPlayer:currentPlayer atDay:currentDay]];
    
    //On sélectionne le premier row
    [self selectFirstRow];
    
    //On met à jour les composants
    [self updateComponent];
}

//On appuie sur la checkbox
- (IBAction)onPushCheckbox:(UITapGestureRecognizer *)gesture
{
    //On récupère la checkbox
    DDCustomCheckbox *customCheckBox = (DDCustomCheckbox *)gesture.view;
    
    //On met à jour le booléen
    [customCheckBox setIsChecked:(!customCheckBox.isChecked)];
    
    //On récupère l'évènement et on le met à jour
    Event *event = [self.arrayEvent objectAtIndex:customCheckBox.tag];
    [event setIsFinished:[NSNumber numberWithBool:customCheckBox.isChecked]];
    [[DDDatabaseAccess instance] saveContext:nil];
    
    //On update la checkbox
    [customCheckBox setNeedsDisplay];
    
    [self.delegate updateComponentWithEventSelected];
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
    [[cell contentView] setBackgroundColor:COULEUR_TRANSPARENT];
    [cell.imageViewCategoryColor setBackgroundColor:[dictColor objectForKey:event.task.categories.name]];
    [cell.labelTask setTextColor:COULEUR_BLACK];
    [cell.labelTask setFont:POLICE_EVENT_TASK_NAME];
    [cell.labelTask setText:event.task.name];
    [cell.labelInfo setTextColor:COULEUR_BLACK];
    [cell.labelInfo setFont:POLICE_EVENT_TASK_INFO];
    [cell.labelInfo setText:[NSString stringWithFormat:@"%@ : %i points", event.task.categories.name, [event.task.point intValue]]];
    [cell.imageViewSeparation setBackgroundColor:COULEUR_BACKGROUND];
    [cell.customCheckbox setTag:indexPath.row];
    [cell.customCheckbox setIsChecked:event.isFinished.boolValue];
    
    if ([[cell.customCheckbox gestureRecognizers] count] == 0)
    {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPushCheckbox:)];
        [cell.customCheckbox addGestureRecognizer:gesture];
    }
    
    //On change la couleur de la cellule suivant si c'est la cellule sélecitonné ou non
    if ([event.task.name isEqualToString:self.currentEvent.task.name])
    {
        [cell.customCheckbox setIsSelected:YES];
        [cell setBackgroundColor:COULEUR_CELL_SELECTED];
    }
    else
    {
        [cell.customCheckbox setIsSelected:NO];
        [cell setBackgroundColor:COULEUR_WHITE];
    }
    
    //On redessine la checkbox
    [cell.customCheckbox setNeedsDisplay];
    
    return cell;
}

//On ouvre la cellule sélectionné
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableViewEvents isEditing] == false)
    {
        [self setCurrentEvent:[self.arrayEvent objectAtIndex:indexPath.row]];
        
        //On met à jour les composants
        [[self delegate] updateComponentWithEventSelected];
    }
}

//Suppression de la tache sélectionnée
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [DDCustomAlertView displayAnswerMessage:@"Voulez vous vraiment supprimer cet évènement" withDelegate:self andSetTag:indexPath.row];
    }
}

//Pour pouvoir swiper pour supprimer
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark - UIAlerViewDelegate fonctions

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //si on a répondu oui, on supprime le joueur
    if (buttonIndex == 0)
    {
        Event *event = [self.arrayEvent objectAtIndex:alertView.tag];
        
        //On supprime l'évènement
        [[DDDatabaseAccess instance] deleteEvent:event];
        [self.arrayEvent removeObjectAtIndex:alertView.tag];
        
        //On recharge la tableView
        [self.tableViewEvents deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:alertView.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
        //On rafraichi les données
        [self updateComponent];
    }
}

@end
