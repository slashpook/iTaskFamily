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
    
    //On configure la couleur de teinte des switchs
    [self.tableViewEvent.switchRecurrence setOnTintColor:COULEUR_HOME];
    
    //On configure les delegate
    [self.textViewComment setDelegate:self];
    
    //On met en place la barre de navigation
    _custoNavBar = [[DDCustomNavigationBarController alloc] initWithDelegate:self andTitle:@"" andBackgroundColor:COULEUR_HOME andImage:[UIImage imageNamed:@"TaskButtonNavigationBarAdd"]];
    [[self.custoNavBar view] setFrame:CGRectMake(0, 0, 380, 50)];
    [[self.custoNavBar buttonRight] setTitle:@"Sauver" forState:UIControlStateNormal];
    [[self.custoNavBar buttonLeft] setTitle:@"Annuler" forState:UIControlStateNormal];
    [self.view addSubview:self.custoNavBar.view];
    
    //On met en place la notification pour savoir quand le clavier est caché
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    //On met à jour les composants
    [self updateComponent];
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

//On met à jour les composants
- (void)updateComponent
{
    //Suivant si on ajoute ou modifie les données, on configure les composants
    if ([self isModifyEvent] == NO)
    {
        [self.custoNavBar.imageViewBackground setImage:[UIImage imageNamed:@"TaskButtonNavigationBarAdd"]];
        [self.tableViewEvent.labelTacheContent setText:self.task.libelle];
        [self.tableViewEvent.labelDateContent setText:[self formatOccurence]];
        [self.tableViewEvent.switchRecurrence setOn:YES];
        [self.textViewComment setText:@""];
    }
    else
    {
        [self.custoNavBar.imageViewBackground setImage:[UIImage imageNamed:@"TaskButtonNavigationBarAdd"]];
        [self.tableViewEvent.labelTacheContent setText:self.task.libelle];
        [self.tableViewEvent.labelDateContent setText:[self formatOccurence]];
        [self.tableViewEvent.switchRecurrence setOn:[self.eventToModify.recurrent boolValue]];
        [self.textViewComment setText:self.eventToModify.comment];
    }
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
        NSString *dayNumber = [[NSNumber numberWithInteger:[[[DDManagerSingleton instance] arrayWeek] indexOfObject:day]] stringValue];
        
        //On récupère le joueur courant
        Player *currentPlayer = [[DDManagerSingleton instance] currentPlayer];
        NSDate *dateEvent = [[DDManagerSingleton instance] currentDateSelected];
        
        if ((self.tableViewEvent.switchRecurrence.isOn == YES && self.isModifyEvent == NO) || (self.isModifyEvent == YES))
        {
            //On regarde si on a pas déjà un évènement futur
            NSArray *arrayEvent = [[DDDatabaseAccess instance] getEventsRecurrentForPlayer:currentPlayer atWeekAndYear:[DDHelperController getWeekAndYearForDate:dateEvent] forTask:self.task andDay:dayNumber];
            
            if ([arrayEvent count] > 0 && self.isModifyEvent == NO)
            {
                [DDCustomAlertView displayCustomMessage:[NSString stringWithFormat:@"L'évènement que vous créez est récurrent dans le futur pour le %@. Que souhaitez vous faire ?", day] withDelegate:self andSetTag:0 withFirstChoice:@"Créer l'évènement et mettre à jour les récurrences" secondChoice:@"Annuler" andThirdChoice:@"Créer uniquement cet évènement"];
                return;
            }
            else if (([arrayEvent count] > 0 || [self.eventToModify.recurrenceEnd.weekAndYear intValue] != -1) && self.isModifyEvent == YES)
            {
                [DDCustomAlertView displayCustomMessage:[NSString stringWithFormat:@"L'évènement que vous allez mettre à jour est récurrent dans le futur pour le %@. Que souhaitez vous faire ?", day] withDelegate:self andSetTag:0 withFirstChoice:@"Mettre à jour cet évènement et ses récurrences" secondChoice:@"Annuler" andThirdChoice:@"Mettre à jour uniquement cet évènement"];
                return;
            }
        }
        
        //On sauvegarde la donnée
        [self saveDataForIndexInOccurence:(int)[self.arrayOccurence indexOfObject:day] withOption:ADD_ONLY];
        return;
    }
    else
    {
        [DDCustomAlertView displayErrorMessage:@"Veuillez choisir un ou plusieurs jours pour la tache à accomplir"];
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
                [DDCustomAlertView displayInfoMessage:@"Evènement enregistré"];
            else
                [DDCustomAlertView displayInfoMessage:@"Evènements enregistrés"];
        }
        else
            [DDCustomAlertView displayInfoMessage:@"Evènement modifié"];
        
        //On ferme la vue
        [self.delegate closeEventManagerView];
    }
    else
        [self checkIfEventCanBeCreatedWithIndexOfArrayOccurence:(dayIndex +1)];
}

//On sauvegarde l'event
- (NSString *)saveEventForDay:(NSString *)day forAddEventOption:(AddEventOption)addEventOption
{
    //Corriger quand on est sur l'évènement crée au jour de la modification
    //Message d'erreur si on met l'event sur un jour ou une tache existe déjà
    
    //On récupère les variables qu'on va utiliser plus tard
    NSString *dayNumber = [[NSNumber numberWithInteger:[[[DDManagerSingleton instance] arrayWeek] indexOfObject:day]] stringValue];
    Player *currentPlayer = [[DDManagerSingleton instance] currentPlayer];
    NSDate *dateEvent = [[DDManagerSingleton instance] currentDateSelected];
    NSDate *datePastEvent = [DDHelperController getPreviousWeekForDate:dateEvent];
    NSDate *dateFutureEvent = [DDHelperController getNextWeekForDate:dateEvent];
    NSString *weekAndYear = [DDHelperController getWeekAndYearForDate:dateEvent];
    NSString *pastWeekAndYear = [DDHelperController getWeekAndYearForDate:datePastEvent];
    NSString *futureWeekAndYear = [DDHelperController getWeekAndYearForDate:dateFutureEvent];
    
    //On crée le nouvel évènement
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
    Event *event = [[Event alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    
    //Si on doit faire diverse manipulation
    if (addEventOption == JUST_UPDATE || addEventOption == UPDATE_IN_FUTURE)
    {
        Event *pastEventCloseToNew = nil;
        //On regarde si un évènement antérieur n'est pas déjà récurrent
        if (self.isModifyEvent == NO)
            pastEventCloseToNew = [[DDDatabaseAccess instance] getAnteriorEventsRecurrentForPlayer:currentPlayer closeToWeekAndYear:weekAndYear forTask:self.task andDay:dayNumber];
        else
            pastEventCloseToNew = self.eventToModify;
        
        //Si c'est le cas
        if (pastEventCloseToNew != nil)
        {
            NSString *weekAndYearReccurrence = pastEventCloseToNew.recurrenceEnd.weekAndYear;
            
            //On met à jour l'ancien event
            [pastEventCloseToNew.recurrenceEnd setWeekAndYear:pastWeekAndYear];
            [[DDDatabaseAccess instance] updateEvent:pastEventCloseToNew];
            
            //Si on modifie seulement cet évènement
            if (addEventOption == JUST_UPDATE)
            {
                //On enlève sa récurrence
                [event setRecurrent:[NSNumber numberWithBool:NO]];
                
                //On crée l'évènement futur à celui ci
                Event *futureEventCloseToNew;
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
                futureEventCloseToNew = [[Event alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
                
                //On met à jour les infos sur l'évènement
                [futureEventCloseToNew setDay:pastEventCloseToNew.day];
                [futureEventCloseToNew setRecurrent:[NSNumber numberWithBool:YES]];
                [futureEventCloseToNew setComment:pastEventCloseToNew.comment];
                
                //On sauvegarde l'évènement
                [[DDDatabaseAccess instance] createEvent:futureEventCloseToNew checked:NO forPlayer:currentPlayer forTask:pastEventCloseToNew.achievement.task atWeekAndYear:futureWeekAndYear andRecurrenceEndAtWeekAndYear:weekAndYearReccurrence];
            }
        }
        
        //Si l'évènement écrase les futurs évènements
        if (addEventOption == UPDATE_IN_FUTURE)
        {
            //On regarde si on a pas déjà un évènement futur
            NSArray *arrayEvent = [[DDDatabaseAccess instance] getEventsForPlayer:currentPlayer futureToWeekAndYear:weekAndYear andDay:dayNumber];
            
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
    
    //On met à jour les infos sur l'évènement
    [event setDay:dayNumber];
    [event setComment:self.textViewComment.text];
    
    if (addEventOption == ADD_ONLY || addEventOption == UPDATE_IN_FUTURE)
        [event setRecurrent:[NSNumber numberWithBool:self.tableViewEvent.switchRecurrence.isOn]];
    
    //On sauvegarde l'évènement
//    if (self.isModifyEvent == NO)
        return [[DDDatabaseAccess instance] createEvent:event checked:NO forPlayer:currentPlayer forTask:self.task atWeekAndYear:weekAndYear];
//    else
//        return [[DDDatabaseAccess instance] updateEvent:event forPlayer:currentPlayer forTask:self.task atWeekAndYear:weekAndYear];
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
            [self saveDataForIndexInOccurence:alertView.tag withOption:UPDATE_IN_FUTURE];
        else
            [self saveDataForIndexInOccurence:alertView.tag withOption:JUST_UPDATE];
    }
}

@end
