//
//  DDEventManagerViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 20/02/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDEventManagerViewController.h"


@interface DDEventManagerViewController ()

@end

@implementation DDEventManagerViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //On initialise le tableau
        _arrayOccurence = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.view setBackgroundColor:COULEUR_BACKGROUND];
    
    //On cache la navigation bar
    [self.navigationController setNavigationBarHidden:YES];
    
    //On configure l'arrondi des vues et composants
    [self.navigationController.view.layer setCornerRadius:10.0];
    [self.navigationController.view.layer setMasksToBounds:YES];
    [self.textViewComment.layer setCornerRadius:10.0];
    
    //On set la police et la couleur des label et textfield
    [[self labelInformation] setFont:POLICE_EVENT_TITLE];
    [[self labelInformation] setTextColor:COULEUR_BLACK];
    [[self labelCommentaire] setFont:POLICE_EVENT_TITLE];
    [[self labelCommentaire] setTextColor:COULEUR_BLACK];
    [[self.tableViewEvent labelTacheTitre] setFont:POLICE_EVENT_CELL];
    [[self.tableViewEvent labelTacheTitre] setTextColor:COULEUR_BLACK];
    [[self.tableViewEvent labelTacheContent] setFont:POLICE_EVENT_CELL];
    [[self.tableViewEvent labelTacheContent] setTextColor:COULEUR_BLACK];
    [[self.tableViewEvent labelDateTitre] setFont:POLICE_EVENT_CELL];
    [[self.tableViewEvent labelDateTitre] setTextColor:COULEUR_BLACK];
    [[self.tableViewEvent labelDateContent] setFont:POLICE_EVENT_CELL];
    [[self.tableViewEvent labelDateContent] setTextColor:COULEUR_BLACK];
    [[self.tableViewEvent labelRecurrence] setFont:POLICE_EVENT_CELL];
    [[self.tableViewEvent labelRecurrence] setTextColor:COULEUR_BLACK];
    [[self textViewComment] setFont:POLICE_EVENT_CELL];
    [[self textViewComment] setTextColor:COULEUR_BLACK];
    
    //On configure les delegate
    [self.textViewComment setDelegate:self];
    
    //On met en place la barre de navigation
    _custoNavBar = [[DDCustomNavigationBarController alloc] initWithDelegate:self andTitle:@"" andBackgroundColor:[DDHelperController getMainTheme] andImage:[UIImage imageNamed:@"TaskButtonNavigationBarAdd"]];
    [[self.custoNavBar view] setFrame:CGRectMake(0, 0, 380, 50)];
    [[self.custoNavBar buttonRight] setTitle:NSLocalizedString(@"SAUVER", nil) forState:UIControlStateNormal];
    [[self.custoNavBar buttonLeft] setTitle:NSLocalizedString(@"ANNULER", nil) forState:UIControlStateNormal];
    [self.view addSubview:self.custoNavBar.view];
    
    //On met en place la notification pour savoir quand le clavier est caché
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    //On met en place la notification pour mettre à jour le theme
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTheme)
                                                 name:UPDATE_THEME
                                               object:nil];
    
    //On met à jour les composants
    [self updateComponent];
    [self updateTheme];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self setTableViewEvent:segue.destinationViewController];
    [self.tableViewEvent setDelegate:self];
}


#pragma mark - Controller fonctions

//Fonction appelé avant d'ouvrir cette vu
- (void)initiateComponent
{
    //Suivant si on ajoute ou modifie les données, on configure les composants
    if ([self isModifyEvent] == NO)
    {
        [self.custoNavBar.imageViewBackground setImage:[UIImage imageNamed:@"TaskButtonNavigationBarAdd"]];
        [self.tableViewEvent.switchRecurrence setOn:YES];
        [self.textViewComment setText:@""];
    }
    else
    {
        [self.custoNavBar.imageViewBackground setImage:[UIImage imageNamed:@"TaskButtonNavigationBarAdd"]];
        [self.tableViewEvent.switchRecurrence setOn:[self.eventToModify.recurrent boolValue]];
        [self.textViewComment setText:self.eventToModify.comment];
    }
    
    [self updateComponent];
}

//On met à jour les composants
- (void)updateComponent
{
    [self.tableViewEvent.labelTacheContent setText:self.task.libelle];
    [self.tableViewEvent.labelDateContent setText:[self formatOccurence]];
}

//On met à jour le theme
- (void)updateTheme
{
    [self.custoNavBar.view setBackgroundColor:[DDHelperController getMainTheme]];
    [self.tableViewEvent.switchRecurrence setOnTintColor:[DDHelperController getMainTheme]];
}

//On affiche correctement le string
-(NSString *)formatOccurence
{
    NSString *occurenceString = [NSMutableString string];
    
    //On vas remplir la cellules avec les jours rentrés
    for (int i = 0; i < [self.arrayOccurence count]; i++)
    {
        if ([self.arrayOccurence count] == 7) {
            occurenceString = SEMAINE_ENTIERE;
        }
        else if ([self.arrayOccurence count] < 3)
        {
            if ([self.arrayOccurence count] == 2 && [self.arrayOccurence containsObject:SAMEDI] && [self.arrayOccurence containsObject:DIMANCHE])
            {
                occurenceString = WEEK_END;
                break;
            }
            else
            {
                if (i==0)
                    occurenceString = [occurenceString stringByAppendingFormat:@"%@", [self.arrayOccurence objectAtIndex:i]];
                else
                    occurenceString = [occurenceString stringByAppendingFormat:@", %@", [self.arrayOccurence objectAtIndex:i]];
            }
        }
        else if ([self.arrayOccurence count] == 5 && [self.arrayOccurence containsObject:SAMEDI] == false && [self.arrayOccurence containsObject:DIMANCHE] == false) {
            occurenceString = JOUR_SEMAINE;
            break;
        }
        else
        {
            if (i==0)
                occurenceString = [occurenceString stringByAppendingFormat:@"%@", [self.arrayOccurence objectAtIndex:i]];
            else
                occurenceString = [occurenceString stringByAppendingFormat:@", %@", [[self.arrayOccurence objectAtIndex:i] substringToIndex:3]];
        }
    }
    
    return occurenceString;
}

//On sauvegarde la donnée avec le jour rentré à l'index donné
- (void)checkIfEventCanBeCreatedWithIndexOfArrayOccurence:(int)dayIndex
{
    //On teste d'abord si tous les champs obligatoires sont remplis
    if ([self.arrayOccurence count] > 0)
    {
        //On récupère l'occurence à créer
        NSString *day = [self.arrayOccurence objectAtIndex:dayIndex];
        NSString *dayNumberInString = [[NSNumber numberWithInteger:[[[DDManagerSingleton instance] arrayWeek] indexOfObject:day]] stringValue];
        
        //On récupère le joueur courant
        Player *currentPlayer = [[DDManagerSingleton instance] currentPlayer];
        NSDate *dateEvent = [[DDManagerSingleton instance] currentDateSelected];
        
        if ((self.tableViewEvent.switchRecurrence.isOn == YES && self.isModifyEvent == NO) || (self.isModifyEvent == YES))
        {
            //On regarde si on a pas déjà un évènement futur
            NSArray *arrayEvent = [[DDDatabaseAccess instance] getEventsRecurrentForPlayer:currentPlayer atWeekAndYear:[DDHelperController getWeekAndYearForDate:dateEvent] forTask:self.task andDay:dayNumberInString];
            
            if ([arrayEvent count] > 0 && self.isModifyEvent == NO)
            {
                [DDCustomAlertView displayCustomMessage:[NSString stringWithFormat:@"%@ %@. %@", NSLocalizedString(@"AJOUT_EVENT_QUESTION_1_PART_1", nil), day, NSLocalizedString(@"AJOUT_EVENT_QUESTION_1_PART_2", nil)] withDelegate:self andSetTag:0 withFirstChoice:NSLocalizedString(@"AJOUT_EVENT_REPONSE_1", nil) secondChoice:NSLocalizedString(@"ANNULER", nil) andThirdChoice:NSLocalizedString(@"AJOUT_EVENT_REPONSE_2", nil)];
                return;
            }
            else if (([arrayEvent count] > 0 || [self.eventToModify.recurrenceEnd.weekAndYear intValue] != -1) && self.isModifyEvent == YES && self.tableViewEvent.switchRecurrence.isOn == YES)
            {
                [DDCustomAlertView displayCustomMessage:[NSString stringWithFormat:@"%@ %@. %@", NSLocalizedString(@"AJOUT_EVENT_QUESTION_2_PART_1", nil), day, NSLocalizedString(@"AJOUT_EVENT_QUESTION_2_PART_2", nil)] withDelegate:self andSetTag:0 withFirstChoice:NSLocalizedString(@"AJOUT_EVENT_REPONSE_3", nil) secondChoice:NSLocalizedString(@"ANNULER", nil) andThirdChoice:NSLocalizedString(@"AJOUT_EVENT_REPONSE_4", nil)];
                return;
            }
            else
            {
                if (self.tableViewEvent.switchRecurrence.isOn == YES)
                    [self saveDataForIndexInOccurence:(int)[self.arrayOccurence indexOfObject:day] withOption:UPDATE_IN_FUTURE];
                else
                    [self saveDataForIndexInOccurence:(int)[self.arrayOccurence indexOfObject:day] withOption:JUST_UPDATE];
                return;
            }
        }
        
        //On sauvegarde la donnée
        [self saveDataForIndexInOccurence:(int)[self.arrayOccurence indexOfObject:day] withOption:ADD_ONLY];
        return;
    }
    else
    {
        [DDCustomAlertView displayErrorMessage:NSLocalizedString(@"CHOIX_JOUR", nil)];
        return;
    }
}

//On sauvegarde la donnée avec l'index pour l'occurence donnée
- (void)saveDataForIndexInOccurence:(int)dayIndex withOption:(AddEventOption)addEventOption
{
    //String qui contiendra un éventuel message d'erreur
    NSString *errorMessage = nil;
    NSString *day = [self.arrayOccurence objectAtIndex:dayIndex];
    
    //On sauvegarde l'event
    errorMessage = [self saveEventForDay:day forAddEventOption:addEventOption];
    if (errorMessage != nil)
    {
        [DDCustomAlertView displayErrorMessage:errorMessage];
        return;
    }
    //Si on a pas de message d'erreur, on met à jour l'historique de la tache
    else
    {
        NSNumber *history = [[NSNumber alloc] initWithInt:([self.task.history intValue] + 1)];
        [self.task setHistory:history];
    }
    
    //Si on arrive à la dernière sauvegarde sans encombre, on affiche les informations
    if (dayIndex == [self.arrayOccurence count] -1)
    {
        //On affiche un message d'info pour indiquer qu'on a crée ou modifié un évènement
        if (self.isModifyEvent == NO)
        {
            if ([self.arrayOccurence count] == 1)
                [DDCustomAlertView displayInfoMessage:NSLocalizedString(@"EVENT_SAUVE", nil)];
            else
                [DDCustomAlertView displayInfoMessage:NSLocalizedString(@"EVENTS_SAUVE", nil)];
        }
        else
            [DDCustomAlertView displayInfoMessage:NSLocalizedString(@"EVENT_MODIFIE", nil)];
        
        //On ferme la vue
        [self.delegate closeEventManagerView];
    }
    else
        [self checkIfEventCanBeCreatedWithIndexOfArrayOccurence:(dayIndex +1)];
}

//On sauvegarde l'event
- (NSString *)saveEventForDay:(NSString *)day forAddEventOption:(AddEventOption)addEventOption
{
    //On récupère les variables qu'on va utiliser plus tard
    NSString *dayNumberInString = [[NSNumber numberWithInteger:[[[DDManagerSingleton instance] arrayWeek] indexOfObject:day]] stringValue];
    //Tableau ou on stocke les jours pour faire les modification des events
    NSMutableArray *arrayDayToUpdate = [[NSMutableArray alloc] initWithObjects:dayNumberInString, nil];
    Player *currentPlayer = [[DDManagerSingleton instance] currentPlayer];
    NSDate *dateEventToManage = [[DDManagerSingleton instance] currentDateSelected];
    NSDate *datePastEventToManage = [DDHelperController getPreviousWeekForDate:dateEventToManage];
    NSDate *dateFutureEventToManage = [DDHelperController getNextWeekForDate:dateEventToManage];
    NSString *weekAndYear = [DDHelperController getWeekAndYearForDate:dateEventToManage];
    NSString *pastWeekAndYear = [DDHelperController getWeekAndYearForDate:datePastEventToManage];
    NSString *futureWeekAndYear = [DDHelperController getWeekAndYearForDate:dateFutureEventToManage];
    
    //On crée une nouvelle entité
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
    Event *newEvent = [[Event alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    
    if (self.isModifyEvent == YES && ![self.eventToModify.day isEqualToString:dayNumberInString])
        [arrayDayToUpdate addObject:self.eventToModify.day];
    
    //Est ce qu'on doit modifier d'autres évènements
    if (addEventOption == JUST_UPDATE || addEventOption == UPDATE_IN_FUTURE)
    {
        for (NSString *dayOfEvent in arrayDayToUpdate)
        {
            Task *task;
            if (([arrayDayToUpdate indexOfObject:dayOfEvent] == 0 && [arrayDayToUpdate count] == 2) || self.isModifyEvent == NO)
                task = self.task;
            else
                task = self.eventToModify.achievement.task;
            
            //On récupère l'évènement récurrent antérieur au nouveau
            Event *pastEvent = [[DDDatabaseAccess instance] getAnteriorEventRecurrentForPlayer:currentPlayer closeToWeekAndYear:weekAndYear forTask:task andDay:dayOfEvent];
            
            //Si on a un event
            if (pastEvent != nil)
            {
                NSString *weekAndYearReccurrence = pastEvent.recurrenceEnd.weekAndYear;
                
                //On met à jour l'ancien event
                [pastEvent.recurrenceEnd setWeekAndYear:pastWeekAndYear];
                [[DDDatabaseAccess instance] updateEvent:pastEvent];
                
                //Si on modifie seulement cet évènement
                if (addEventOption == JUST_UPDATE)
                {
                    //On enlève sa récurrence
                    [newEvent setRecurrent:[NSNumber numberWithBool:NO]];
                    
                    //On crée et copie l'évènement à la semaine suivante
                    Event *futureEventCopy;
                    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
                    futureEventCopy = [[Event alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
                    [futureEventCopy setDay:pastEvent.day];
                    [futureEventCopy setRecurrent:[NSNumber numberWithBool:YES]];
                    [futureEventCopy setComment:pastEvent.comment];
                    
                    //On sauvegarde l'évènement
                    [[DDDatabaseAccess instance] createEvent:futureEventCopy checked:NO forPlayer:currentPlayer forTask:task atWeekAndYear:futureWeekAndYear andRecurrenceEndAtWeekAndYear:weekAndYearReccurrence andForceUpdate:YES];
                }
            }
            
            //Si l'évènement est récurrent dans le futur
            if (addEventOption == UPDATE_IN_FUTURE)
            {
                //On récupère tous les évènements récurrent dans le futur et on les supprime
                NSArray *arrayEvent = [[DDDatabaseAccess instance] getEventsForPlayer:currentPlayer futureToWeekAndYear:weekAndYear forTask:task andDay:dayOfEvent];
                
                if ([arrayEvent count] > 0)
                {
                    for (int i = (int)([arrayEvent count] - 1); i >= 0; i--)
                    {
                        Event *eventToDelete = [arrayEvent objectAtIndex:i];
                        [[DDDatabaseAccess instance] deleteEvent:eventToDelete];
                    }
                }
            }

        }
        
        //Si corresponds à celui qui est à l'origine de la récurrence on le supprime
        if (self.isModifyEvent == YES && [self.eventToModify.achievement.weekAndYear isEqualToString:weekAndYear])
            [[DDDatabaseAccess instance] deleteEvent:self.eventToModify];
    }
    
    //On met à jour les infos sur l'évènement
    [newEvent setDay:dayNumberInString];
    [newEvent setComment:self.textViewComment.text];
    
    if (addEventOption == ADD_ONLY || addEventOption == UPDATE_IN_FUTURE)
        [newEvent setRecurrent:[NSNumber numberWithBool:self.tableViewEvent.switchRecurrence.isOn]];
    
    if (addEventOption == ADD_ONLY)
        return [[DDDatabaseAccess instance] createEvent:newEvent checked:NO forPlayer:currentPlayer forTask:self.task atWeekAndYear:weekAndYear andForceUpdate:NO];
    else
        return [[DDDatabaseAccess instance] createEvent:newEvent checked:NO forPlayer:currentPlayer forTask:self.task atWeekAndYear:weekAndYear andForceUpdate:YES];
}

#pragma mark - Keyboard fonctions

//Fonction appelé lorsque l'on commence l'édition d'un champs
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UP_POPOVER object:[NSNumber numberWithInteger:220]];
}

//Fonction appelé lorsqu'on l'on termine l'édition d'un champs
- (void)keyboardDidHide:(NSNotification *)notif
{
    //On redescend la vue
    [[NSNotificationCenter defaultCenter] postNotificationName:UP_POPOVER object:[NSNumber numberWithInteger:0]];
}


#pragma mark Fonctions de DDOccurenceViewProtocol

-(void)saveOccurencewithArray:(NSMutableArray *)arrayOccurence
{
    //On met à jour le tableau des jours sélectionnés
    [self setArrayOccurence:arrayOccurence];
    
    //On met à jour les composants
    [self updateComponent];
}


#pragma mark DDEventManagerTableView Protocol fonctions

//On sélectionne la cellule
- (void)cellSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    //Si on a sélectionné la vue de sélection de tache
    if (indexPath.row == 0)
    {
        DDCategoriesListEventViewController *categoryEventViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"CategoryEventViewController"];
        [categoryEventViewController setDelegate:self];
        [self.navigationController pushViewController:categoryEventViewController animated:YES];
    }
    
    //Si on a sélectionné la vue de sélection des jours
    if (indexPath.row == 1)
    {
        DDOccurenceViewController *occurenceViewController = [[[DDManagerSingleton instance] storyboard]  instantiateViewControllerWithIdentifier:@"OccurenceViewController"];
        
        //On set le delegate
        [occurenceViewController setDelegate:self];
        
        //On indique dans quel état on est (Ajout ou modification)
        [occurenceViewController setIsModifyEvent:self.isModifyEvent];
        
        //On met à jour le tableau des jours sauvegardés
        [occurenceViewController setArrayOccurenceSaved:self.arrayOccurence];
        
        //On push la vue dans le navigation controller
        [self.navigationController pushViewController:occurenceViewController animated:YES];
    }
}


#pragma mark - NavigationBar fonctions

//On appuie sur le bouton de gauche
- (void)onPushLeftBarButton
{
    //On ferme la vue
    [self.delegate closeEventManagerView];
}

//On appuie sue le bouton de droite
- (void)onPushRightBarButton
{
    [self checkIfEventCanBeCreatedWithIndexOfArrayOccurence:0];
}


#pragma DDTaskEventViewController fonctions

//On sauve la tache
- (void)saveTaskWithTask:(Task *)task
{
    [self setTask:task];
    
    //On met à jour les composants
    [self updateComponent];
}

#pragma mark - UIAlerViewDelegate fonctions

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Si on annule pas l'évènement
    if (buttonIndex != 1)
    {
        if (buttonIndex == 0)
            [self saveDataForIndexInOccurence:(int)alertView.tag withOption:UPDATE_IN_FUTURE];
        else
            [self saveDataForIndexInOccurence:(int)alertView.tag withOption:JUST_UPDATE];
    }
}

@end
