//
//  DDEventInfosViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 02/03/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDEventInfosViewController.h"
#import "DDCustomEventCell.h"
#import "DDCustomCheckbox.h"
#import "DDCustomValidation.h"

@interface DDEventInfosViewController ()

@end

@implementation DDEventInfosViewController
{
    NSString *weekAndYearSelected;
    NSString *currentWeekAndYear;
}


#pragma mark - Fonctions de base

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _arrayEvent = [[NSMutableArray alloc] init];
        weekAndYearSelected = [[NSString alloc] init];
        currentWeekAndYear = [[NSString alloc] init];
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
    [self.labelTask setFont:POLICE_EVENTINFO_TASK];
    [self.labelTask setTextColor:COULEUR_BLACK];
    [self.labelCategory setFont:POLICE_EVENTINFO_BULLE];
    [self.labelCategory setTextColor:COULEUR_WHITE];
    [self.labelPoint setFont:POLICE_EVENTINFO_BULLE];
    [self.labelPoint setTextColor:COULEUR_WHITE];
    [self.textViewComment setFont:POLICE_EVENTINFO_COMMENT];
    [self.textViewComment setTextColor:COULEUR_BLACK];
    
    //On configure la tableView
    [self.tableViewEvents registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellTableView"];
    [self.tableViewEvents registerClass:[UITableViewCell class] forCellReuseIdentifier:@"AddCellTableView"];
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
    
    //On met à jour la date actuelle et la semaine sélectionnée
    weekAndYearSelected = [DDHelperController getWeekAndYearForDate:[[DDManagerSingleton instance] currentDateSelected]];
    currentWeekAndYear = [DDHelperController getWeekAndYearForDate:[NSDate date]];
    
    //On récupère la tache et la catégory associées à l'event
    Task *task = self.currentEvent.achievement.task;
    CategoryTask *category = self.currentEvent.achievement.task.category;
    
    //On récupère le dictionnaire des couleurs des catégories
    NSDictionary *dictColor = [[DDManagerSingleton instance] dictColor];
    
    //On met à jour le nom de la tache
    [self.labelTask setText:task.libelle];
    
    //On met à jour les 3 carrés de la vue info
    [self.imageViewCategory setBackgroundColor:[dictColor objectForKey:category.libelle]];
    [self.labelCategory setText:category.libelle];
    [self.imageViewPoints setBackgroundColor:[dictColor objectForKey:category.libelle]];
    [self.labelPoint setText:task.point.stringValue];
    [self.imageViewRepetition setBackgroundColor:[dictColor objectForKey:category.libelle]];
    if ([self.currentEvent.recurrent boolValue] == YES)
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
    NSDate *dateEvent = [[DDManagerSingleton instance] currentDateSelected];
    [self setArrayEvent:[NSMutableArray arrayWithArray:[[DDDatabaseAccess instance] getEventsForPlayer:currentPlayer atWeekAndYear:[DDHelperController getWeekAndYearForDate:dateEvent] andDay:currentDay]]];
    
    //On sélectionne le premier row
    [self selectFirstRow];
    
    //On met à jour les composants
    [self updateComponent];
}

//On demande à supprimer l'élément sélectionné
- (void)deleteEvent:(Event *)event
{
    if (![[[event recurrenceEnd] weekAndYear] isEqualToString:@"-1"])
    {
        [DDCustomAlertView displayCustomMessage:@"Vous allez supprimer un évènement récurrent. Que souhaitez vous faire ?" withDelegate:self andSetTag:(int)[self.arrayEvent indexOfObject:event] withFirstChoice:@"Supprimer cet évènement et ses récurrences" secondChoice:@"Annuler" andThirdChoice:@"Supprimer uniquement cet évènement"];
    }
    else
    {
        [DDCustomAlertView displayAnswerMessage:@"Voulez vous vraiment supprimer cet évènement ?" withDelegate:self andSetTag:(int)[self.arrayEvent indexOfObject:event]];
    }
}

//On appuie sur le bouton pour supprimer des évènements
- (IBAction)onPushDeleteEventButon:(id)sender
{
    [self deleteEvent:self.currentEvent];
}

//On appuie sur le bouton pour modifier un évènement
- (IBAction)onPushModifyEventButton:(id)sender
{
    [[self delegate] updateEvent];
}

//On appuie sur la checkbox
- (IBAction)onPushCheckbox:(UITapGestureRecognizer *)gesture
{
    //On peut checker que si on est sur une semaine passé ou actuelle
    if ([weekAndYearSelected intValue] <= [currentWeekAndYear intValue])
    {
        //On récupère le joueur en courant
        Player *currentPlayer = [[DDManagerSingleton instance] currentPlayer];
        
        //On récupère la checkbox
        DDCustomCheckbox *customCheckBox = (DDCustomCheckbox *)gesture.view;
        
        //On met à jour le booléen
        [customCheckBox setIsChecked:(!customCheckBox.isChecked)];
        
        //On récupère l'évènement et on le met à jour
        Event *event = [self.arrayEvent objectAtIndex:customCheckBox.tag];
        
        //On vérifie si on est sur un event récurrent (qui n'existe pas) auquel cas, on le crée et on le met à jour
        if ([event.achievement.weekAndYear isEqualToString:weekAndYearSelected])
        {
            [event setChecked:[NSNumber numberWithBool:customCheckBox.isChecked]];
            [[DDDatabaseAccess instance] updateEvent:event];
        }
        else
        {
            //On bouge la récurrence
            [event.recurrenceEnd setWeekAndYear:@"-1"];
            [[DDDatabaseAccess instance] updateEvent:event];
            
            //On crée le nouvel évènement
            Event *newEvent;
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
            newEvent = [[Event alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
            
            //On met à jour les infos sur l'évènement
            [newEvent setDay:event.day];
            [newEvent setRecurrent:[NSNumber numberWithBool:YES]];
            [newEvent setComment:event.comment];
            [[DDDatabaseAccess instance] createEvent:newEvent forPlayer:currentPlayer forTask:event.achievement.task atWeekAndYear:weekAndYearSelected];
            
            [newEvent setChecked:[NSNumber numberWithBool:YES]];
            [[DDDatabaseAccess instance] updateEvent:newEvent];
        }
        
        //On update la checkbox
        [customCheckBox setNeedsDisplay];
        
        [self.delegate updateComponentWithEventSelected];
    }
    else
    {
        [DDCustomAlertView displayInfoMessage:@"Vous ne pouvez pas cocher un évènement d'une semaine qui n'est pas passé ou en cours"];
    }
}


#pragma mark Delegate Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Si on est sur une semaine présente ou future, on ajoute le bouton pour créer des taches
    if ([currentWeekAndYear intValue] <= [weekAndYearSelected intValue])
        return [self.arrayEvent count] + 1;
    else
        return [self.arrayEvent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Si on est sur la dernière cellule
    if ([self.arrayEvent count] == 0 || indexPath.row == [self.arrayEvent count])
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddEventCell" forIndexPath:indexPath];
        return cell;
    }
    
    //On récupère la cellule
    DDCustomEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomEventCell" forIndexPath:indexPath];
    
    //On récupère le dictionnaire des couleurs des catégories
    NSDictionary *dictColor = [[DDManagerSingleton instance] dictColor];
    
    //On récupère l'event que l'on va afficher dans la cellule
    Event *event = [self.arrayEvent objectAtIndex:indexPath.row];
    
    //On récupère la tache et la catégory associées à l'event
    Task *task = event.achievement.task;
    CategoryTask *category = event.achievement.task.category;
    NSString *currentWeakAndYear = [DDHelperController getWeekAndYearForDate:[[DDManagerSingleton instance] currentDateSelected]];
    
    //On configure les infos de la cellule
    [[cell contentView] setBackgroundColor:COULEUR_TRANSPARENT];
    [cell.imageViewCategoryColor setBackgroundColor:[dictColor objectForKey:category.libelle]];
    [cell.labelTask setTextColor:COULEUR_BLACK];
    [cell.labelTask setFont:POLICE_EVENTINFOCELL_TASK];
    [cell.labelTask setText:task.libelle];
    [cell.labelInfo setTextColor:COULEUR_BLACK];
    [cell.labelInfo setFont:POLICE_EVENTINFOCELL_POINT];
    [cell.labelInfo setText:[NSString stringWithFormat:@"%@ : %i points", category.libelle, [task.point intValue]]];
    [cell.imageViewSeparation setBackgroundColor:COULEUR_BACKGROUND];
    [cell.customCheckbox setTag:indexPath.row];
    
    //On vérifie si on est sur une récurrence ou un vrai jour
    if ([event.achievement.weekAndYear isEqualToString:currentWeakAndYear])
        [cell.customCheckbox setIsChecked:event.checked.boolValue];
    else
        [cell.customCheckbox setIsChecked:NO];
    
    if ([[cell.customCheckbox gestureRecognizers] count] == 0)
    {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPushCheckbox:)];
        [cell.customCheckbox addGestureRecognizer:gesture];
    }
    
    //On change la couleur de la cellule suivant si c'est la cellule sélecitonnée ou non
    if ([task.libelle isEqualToString:self.currentEvent.achievement.task.libelle])
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
    //Si on est sur la cellule pour ajouter un event
    if ([self.arrayEvent count] == 0 || indexPath.row == [self.arrayEvent count])
    {
        [[self delegate] addEvent];
        return;
    }
    
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
        //On récupère l'event à supprimer pour adapter la réponse
        Event *eventToDelete= [self.arrayEvent objectAtIndex:indexPath.row];
        [self deleteEvent:eventToDelete];
    }
}

//Pour pouvoir swiper pour supprimer
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Si on est sur la dernière cellule
    if ([self.arrayEvent count] == 0 || indexPath.row == [self.arrayEvent count])
        return NO;
    else
        return YES;
}


#pragma mark - UIAlerViewDelegate fonctions

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Si on annule pas l'évènement
    if (buttonIndex != 1)
    {
        //On récupère l'event et le player
        Event *currentEvent = [self.arrayEvent objectAtIndex:alertView.tag];
        Player *player = [[DDManagerSingleton instance] currentPlayer];
        
        //On récupère la date sélectionnée ainsi que la date à semaine -1 et semaine +1
        NSDate *dateSelected = [DDHelperController getDateForYear:[[weekAndYearSelected substringToIndex:4] intValue] week:[[weekAndYearSelected substringFromIndex:4] intValue] andDay:[currentEvent.day intValue]];
        NSDate *dateNextWeekAndDay = [DDHelperController getNextWeekForDate:dateSelected];
        NSDate *datePreviousWeekAndDay = [DDHelperController getPreviousWeekForDate:dateSelected];
        
        //On regarde si on a pas déjà une récurrence la semaine d'après
        BOOL eventExistInFuture = [[DDDatabaseAccess instance] eventExistForPlayer:player atWeekAndYear:[DDHelperController getWeekAndYearForDate:dateNextWeekAndDay] andDay:currentEvent.day];
        
        //Si on doit supprimer tous les évènement récurrent pour la tache récupérée
        if (buttonIndex == 0)
        {
            //On regarde si on a pas déjà un évènement futur
            NSArray *arrayEvent = [[DDDatabaseAccess instance] getEventsForPlayer:player futureToWeekAndYear:[DDHelperController getWeekAndYearForDate:dateSelected] andDay:currentEvent.day];
            
            if ([arrayEvent count] > 0)
            {
                for (int i = (int)([arrayEvent count] - 1); i >= 0; i--)
                {
                    Event *eventToDelete = [arrayEvent objectAtIndex:i];
                    [[DDDatabaseAccess instance] deleteEvent:eventToDelete];
                }
            }
        }
        //Si on supprime seulement l'event selectionné et qu'on a pas de récurrence future, on crée un nouvel évènement
        else if (buttonIndex == 2 && eventExistInFuture == NO)
        {
            //On regarde si on a pas déjà un évènement futur
            Event *eventInFuture = [[DDDatabaseAccess instance] getEventForPlayer:player futureToWeekAndYear:[DDHelperController getWeekAndYearForDate:dateSelected] andDay:currentEvent.day];
            
            //On crée le nouvel évènement
            Event *event;
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
            event = [[Event alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
            
            //On met à jour les infos sur l'évènement
            [event setDay:currentEvent.day];
            [event setRecurrent:[NSNumber numberWithBool:YES]];
            [event setComment:currentEvent.comment];
            
            //Si on a un évènement récurrent dans le futur, on récupère sa date pour mettre une date de fin à la récurrence de l'event qu'on cré
            if (eventInFuture != nil)
            {
                //On crée la date de fin de récurrence
                RecurrenceEnd *recurrenceEnd = [NSEntityDescription insertNewObjectForEntityForName:@"RecurrenceEnd"
                                                                             inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
                
                NSDate *dateEvent = [DDHelperController getDateForYear:[[eventInFuture.achievement.weekAndYear substringToIndex:4] intValue] week:[[eventInFuture.achievement.weekAndYear substringFromIndex:4] intValue] andDay:[currentEvent.day intValue]];
                NSDate *datePreviousEvent = [DDHelperController getPreviousWeekForDate:dateEvent];
                [recurrenceEnd setWeekAndYear:[DDHelperController getWeekAndYearForDate:datePreviousEvent]];

                [[DDDatabaseAccess instance] createEvent:event forPlayer:player forTask:currentEvent.achievement.task atWeekAndYear:[DDHelperController getWeekAndYearForDate:dateNextWeekAndDay] andRecurrenceEnd:recurrenceEnd];
            }
            else
                [[DDDatabaseAccess instance] createEvent:event forPlayer:player forTask:currentEvent.achievement.task atWeekAndYear:[DDHelperController getWeekAndYearForDate:dateNextWeekAndDay]];
        }
        
        //Si l'event ne corresponds pas à celui qui est à l'origine de la récurrence on l'update
        if (![currentEvent.achievement.weekAndYear isEqualToString:weekAndYearSelected])
        {
            [[currentEvent recurrenceEnd] setWeekAndYear:[DDHelperController getWeekAndYearForDate:datePreviousWeekAndDay]];
            [[DDDatabaseAccess instance] updateEvent:currentEvent];
        }
        //Sinon on le supprime
        else
            [[DDDatabaseAccess instance] deleteEvent:currentEvent];
        
        //On met à jour le tableau et on recharge la tableView
        [self.arrayEvent removeObjectAtIndex:alertView.tag];
        [self.tableViewEvents deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:alertView.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
        //On met à jour les composants
        [self.delegate updateComponentWithEventSelected];
        
        //S'il reste au moins un event
        if ([self.arrayEvent count] > 0)
        {
            [self setCurrentEvent:[self.arrayEvent objectAtIndex:0]];
            [self updateComponent];
        }
    }
}

@end
