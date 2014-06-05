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
        [self.tableViewEvent.labelTacheContent setText:self.eventToModify.achievement.task.libelle];
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

//On sauvegarde l'event
- (NSString *)saveEventForDay:(NSString *)day
{
    //On récupère le numéro du jour de la semaine
    NSString *dayNumber = [[NSNumber numberWithInteger:[[[DDManagerSingleton instance] arrayWeek] indexOfObject:day]] stringValue];
    
    //On récupère le joueur en courant
    Player *currentPlayer = [[DDManagerSingleton instance] currentPlayer];
    NSDate *dateEvent = [[DDManagerSingleton instance] currentDateSelected];
    
    //On crée le nouvel évènement ou récupère l'event à modifier
    Event *event;
    if (self.isModifyEvent == NO)
    {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
        event = [[Event alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    }
    else
        event = self.eventToModify;
    
    //On met à jour les infos sur l'évènement
    [event setDay:dayNumber];
    [event setRecurrent:[NSNumber numberWithBool:self.tableViewEvent.switchRecurrence.isOn]];
    [event setComment:self.textViewComment.text];
    
    if (self.isModifyEvent == NO)
    {
        return [[DDDatabaseAccess instance] createEvent:event forPlayer:currentPlayer forTask:self.task atWeekAndYear:[DDHelperController getWeekAndYearForDate:dateEvent]];
    }
    else
    {
        return [[DDDatabaseAccess instance] updateEvent:event forPlayer:currentPlayer forTask:self.task atWeekAndYear:[DDHelperController getWeekAndYearForDate:dateEvent]];
    }
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
    //String qui contiendra un éventuel message d'erreur
    NSString *errorMessage = nil;
    
    //On teste d'abord si tous les champs obligatoires sont remplis
    if ([self.arrayOccurence count] > 0)
    {
        //On boucle sur le nombre d'occurence de l'évènement
        for (NSString *day in self.arrayOccurence)
        {
            //On sauvegarde l'event
            errorMessage = [self saveEventForDay:day];
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
        }
    }
    else
    {
        [DDCustomAlertView displayErrorMessage:@"Veuillez choisir un ou plusieurs jours pour la tache à accomplir"];
        return;
    }
    
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


#pragma DDTaskEventViewController fonctions

//On sauve la tache
- (void)saveTaskWithTask:(Task *)task
{
    [self setTask:task];
    
    //On met à jour les composants
    [self updateComponent];
}

@end
