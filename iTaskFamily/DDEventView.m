//
//  DDEventView.m
//  iTaskFamily
//
//  Created by Damien DELES on 24/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDEventView.h"
#import "DDPopOverViewController.h"
#import "DDCustomButton.h"
#import "DDCustomButtonNotification.h"

@implementation DDEventView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    //On dessine la vue
    [self.layer setCornerRadius:10.0];
    [self.layer setMasksToBounds:YES];
    
    //On configure les polices et couleur des boutons et labels
    [[self.buttonAddPlayer titleLabel] setFont:POLICE_EVENT_NO_PLAYER];
    [[self.buttonBigAddEvent titleLabel] setFont:POLICE_EVENT_NO_EVENT];
    [self.labelNoEvent setFont:POLICE_EVENT_NO_EVENT];
    [self.imageViewHeader setBackgroundColor:COULEUR_BLACK];
    [self.buttonToday setColorTitleEnable:COULEUR_WHITE];
    
    //On initialise le tableau des notifications et les boutons
    [[self.buttonLundi labelDay] setText:@"LUN"];
    [[self.buttonMardi labelDay] setText:@"MAR"];
    [[self.buttonMercredi labelDay] setText:@"MER"];
    [[self.buttonJeudi labelDay] setText:@"JEU"];
    [[self.buttonVendredi labelDay] setText:@"VEN"];
    [[self.buttonSamedi labelDay] setText:@"SAM"];
    [[self.buttonDimanche labelDay] setText:@"DIM"];
    _arrayWeekNotification = [[NSArray alloc] initWithObjects:self.buttonLundi, self.buttonMardi, self.buttonMercredi, self.buttonJeudi, self.buttonVendredi, self.buttonSamedi, self.buttonDimanche, nil];
    for (DDCustomButtonNotification *buttonNotification in self.arrayWeekNotification)
        [[buttonNotification labelNumberNotification] setText:@""];
    
    //On initialise le popOver, le navigation controller et le playerManagerViewController
    UIStoryboard *storyboard = [[DDManagerSingleton instance] storyboard];
    _popOverViewController = [storyboard instantiateViewControllerWithIdentifier:@"PopOverViewController"];
    _eventManagerViewController = [storyboard instantiateViewControllerWithIdentifier:@"EventManagerViewController"];
    [self.eventManagerViewController setDelegate:self];
    _navigationEventManagerViewController = [[UINavigationController alloc] initWithRootViewController:self.eventManagerViewController];
    
    //On met à jour les données pour que l'on soit sur aujourd'hui
    [self setDataToSelectToday];
    
    //On rafraichis les composants et on met à jour le thème
    [self updateComponent];
    [self updateTheme];
}


#pragma mark - View fonctions

//Fonction pour mettre le theme à jour
- (void)updateTheme
{
    [self.labelNoEvent setTextColor:[DDHelperController getMainTheme]];
    [self.buttonAddPlayer setColorTitleEnable:[DDHelperController getMainTheme]];
    [self.buttonAddPlayer setColorTitleDisable:[DDHelperController getMainTheme]];
    [self.buttonAddPlayer setNeedsDisplay];
    [self.buttonBigAddEvent setColorTitleEnable:[DDHelperController getMainTheme]];
    [self.buttonBigAddEvent setColorTitleDisable:[DDHelperController getMainTheme]];
    [self.buttonBigAddEvent setNeedsDisplay];
    [self.imageViewSelection setBackgroundColor:[DDHelperController getMainTheme]];
}

//On met à jour les composants en fonctions des joueurs
- (void)updateComponent
{
    //On récupère le joueur courant et la date du jour sélectionné
    Player *currentPlayer = [[DDManagerSingleton instance] currentPlayer];
    NSDate *dateEvent = [[DDManagerSingleton instance] currentDateSelected];
    NSString *currentWeekAndYear = [DDHelperController getWeekAndYearForDate:[NSDate date]];
    NSString *weekAndYearSelected = [DDHelperController getWeekAndYearForDate:dateEvent];
    
    [self.eventInfosViewController.view setHidden:YES];
    [self.labelNoEvent setHidden:YES];
    [self.imageViewPlus setHidden:NO];
    
    //si le joueur n'existe pas on désactive les boutons
    if (currentPlayer == nil)
    {
        [self.buttonAddPlayer setHidden:NO];
        [self.buttonBigAddEvent setHidden:YES];
        [[self imageViewPlus] setFrame:CGRectMake(self.buttonAddPlayer.frame.origin.x + 10, self.buttonAddPlayer.frame.origin.y + 10, 40, 40)];
    }
    //Sinon on vérifie qu'il y ai des évènements
    else
    {
        [self.buttonAddPlayer setHidden:YES];
        [self.buttonBigAddEvent setHidden:YES];
        [self.eventInfosViewController.buttonDeleteEvent setEnabled:YES];
        [self.eventInfosViewController.buttonModifyEvent setEnabled:YES];

        //Si il n'y a pas d'évènement on désactive certains boutons.
        if ([[[DDDatabaseAccess instance] getEventsForPlayer:currentPlayer atWeekAndYear:weekAndYearSelected andDay:self.daySelected] count] > 0)
        {
            [self.imageViewPlus setHidden:YES];
            [self.eventInfosViewController.view setHidden:NO];
            [self.eventInfosViewController getEventsForDay:self.daySelected];
            //Si on a fini la tache sélectionnée, on désactive le bouton pour modifier l'évènement
            if (([self.eventInfosViewController.currentEvent.checked boolValue] == YES && [self.eventInfosViewController.currentEvent.achievement.weekAndYear intValue] == [weekAndYearSelected intValue]) || [weekAndYearSelected intValue] < [currentWeekAndYear intValue])
                [[self.eventInfosViewController buttonModifyEvent] setEnabled:NO];
        }
        else
        {
            [[self imageViewPlus] setFrame:CGRectMake(self.buttonBigAddEvent.frame.origin.x + 10, self.buttonBigAddEvent.frame.origin.y + 10, 40, 40)];
            
            //On affiche le bouton pour afficher des events que si on est dans le présent ou le futur
            if ([currentWeekAndYear intValue] <= [weekAndYearSelected intValue])
                [self.buttonBigAddEvent setHidden:NO];
            else
            {
                [self.imageViewPlus setHidden:YES];
                [self.buttonBigAddEvent setHidden:YES];
                [self.labelNoEvent setHidden:NO];
            }
        }
    }
    
    //On change la couleur du header pour indiquer si on est sur la semaine courante ou non
    if ([currentWeekAndYear intValue] == [weekAndYearSelected intValue])
        [self.imageViewHeader setBackgroundColor:COULEUR_BLACK];
    else
        [self.imageViewHeader setBackgroundColor:COULEUR_GREY];
    
    [self.labelDateSelected setText:[DDHelperController getDateInLetterForDate:dateEvent]];
    
    //On met à jour les notifications
    [self updateNotifications];
}

//On met à jour la couleur des boutons
- (void)updateColorButtonDays
{
    for (DDCustomButtonNotification *buttonNotification in self.arrayWeekNotification) {
        [buttonNotification setIsSelected:NO];
        [buttonNotification updateComponent];
    }
}

//On se positionne sur le bon jour
- (void)updatePositionOfSelectedDay
{
    //On met le booléen à NO pour empêcher de lancer l'animation
    [self setMustAnimateSelectionDay:NO];
    [self onPushDayButton:[self viewWithTag:(self.daySelected.intValue +1)]];
}

//On met à jour les notifications
- (void)updateNotifications
{
    //On boucle sur le tableau de notif, on les caches ou non en fonction
    for (DDCustomButtonNotification *buttonNotification in self.arrayWeekNotification)
    {
        //On récupère l'index
        NSString *dayOfNotification = [NSString stringWithFormat:@"%i", (int)[self.arrayWeekNotification indexOfObject:buttonNotification]];
        NSDate *dateEvent = [[DDManagerSingleton instance] currentDateSelected];
        
        //On récupère le compteur
        int compteur = [[DDDatabaseAccess instance] getNumberOfEventUncheckedForPlayer:[[DDManagerSingleton instance] currentPlayer] forWeekAndYear:[DDHelperController getWeekAndYearForDate:dateEvent] andDay:dayOfNotification];
        
        //On met à jour le label du compteur d'évènement non terminé
        [[buttonNotification labelNumberNotification] setText:[NSString stringWithFormat:@"%i", compteur]];
        
        [buttonNotification updateComponent];
    }
}

//On appuie sur un des boutons
- (IBAction)onPushDayButton:(id)sender
{
    //On remet la couleur des boutons en noir
    [self updateColorButtonDays];
    
    //En fonction de l'état du booléen, on lance ou non une animation
    if (self.mustAnimateSelectionDay == YES) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.imageViewSelection setFrame:[(DDCustomButtonNotification *)sender frame]];
        } completion:^(BOOL finished) {
            [(DDCustomButtonNotification *)sender setIsSelected:YES];
            [sender updateComponent];
        }];
    }
    else
    {
        [self.imageViewSelection setFrame:[(DDCustomButtonNotification *)sender frame]];
        [(DDCustomButtonNotification *)sender setIsSelected:YES];
        [sender updateComponent];
        [self setMustAnimateSelectionDay:YES];
    }
    
    //On met l'évènement courant à nil pour tout remettre à 0 dans la sélection
    [self.eventInfosViewController setCurrentEvent:nil];
    
    //On récupère le tag du bouton et on lui enlève un car la première entrée d'un tableau est 0
    int daySelectedInNumber = (int)([(UIButton *)sender tag] - 1);
    //On récupère la différence de jour et l'ancienne date sélectionnée
    int differenceDay = daySelectedInNumber - [[self daySelected] intValue];
    NSDate *dateEvent = [[DDManagerSingleton instance] currentDateSelected];
    
    //On met à jour la date sélectionnée ainsi que le jour sélectionné
    [[DDManagerSingleton instance] setCurrentDateSelected:[DDHelperController getDateWithNumberOfDifferenceDay:differenceDay forDate:dateEvent]];
    [self setDaySelected:[NSString stringWithFormat:@"%i", daySelectedInNumber]];
    
    [self updateComponent];
}

//On appuie sur le bouton aujourd'hui
- (IBAction)onPushTodayButton:(id)sender
{
    //On met à jour les données
    [self setDataToSelectToday];
    [self onPushDayButton:[self viewWithTag:(self.daySelected.intValue +1)]];
}

//On appuie sur le bouton pour aller sur la semaine précédente
- (IBAction)onPushPreviousWeekButton:(id)sender
{
    NSDate *dateEvent = [[DDManagerSingleton instance] currentDateSelected];
    NSDate *previousWeekDate = [DDHelperController getPreviousWeekForDate:dateEvent];
    
    //On met à jour la date de l'évènement sélectionné
    [[DDManagerSingleton instance] setCurrentDateSelected:previousWeekDate];
    
    //On update la vue
    [self.eventInfosViewController setCurrentEvent:nil];
    [self updateComponent];
}

//On appuie sur le bouton pour aller sur la semaine suivante
- (IBAction)onPushNextWeekButton:(id)sender
{
    NSDate *dateEvent = [[DDManagerSingleton instance] currentDateSelected];
    NSDate *nextWeekDate = [DDHelperController getNextWeekForDate:dateEvent];
    
    //On met à jour la date de l'évènement sélectionné
    [[DDManagerSingleton instance] setCurrentDateSelected:nextWeekDate];
    
    //On update la vue
    [self.eventInfosViewController setCurrentEvent:nil];
    [self updateComponent];
}

//On appuie sur le bouton pour ajouter un évènement
- (IBAction)onPushAddEventButton:(id)sender
{
    //On configure le controller
    [self.eventManagerViewController setIsModifyEvent:NO];
    [self.eventManagerViewController setEventToModify:nil];
    [self.eventManagerViewController setTask:nil];
    [[self.eventManagerViewController arrayOccurence] removeAllObjects];
    [[self.eventManagerViewController arrayOccurence] addObject:[[[DDManagerSingleton instance] arrayWeek]  objectAtIndex:self.daySelected.intValue]];
    [self.eventManagerViewController initiateComponent];
    
    //On ouvre la popUp
    [self openEventManagerViewController];
}

- (IBAction)onPushAddPlayerButton:(id)sender
{
    //On affiche la page d'ajout de joueur
    [[NSNotificationCenter defaultCenter] postNotificationName:ADD_PLAYER object:nil];
}

//On ouvre la popUp
- (void)openEventManagerViewController
{
    //On pop le navigation controller
    [self.navigationEventManagerViewController popToRootViewControllerAnimated:NO];
    
    [[[[[[UIApplication sharedApplication] delegate] window] rootViewController] view] addSubview:self.popOverViewController.view];
    
    //On présente la popUp
    CGRect frame = self.eventManagerViewController.view.frame;
    [self.popOverViewController presentPopOverWithContentView:self.navigationEventManagerViewController.view andSize:frame.size andOffset:CGPointMake(0, 0)];
}

//Fonction pour mettre à jour les données pour que l'on ai aujourd'hui de sélectionné
- (void)setDataToSelectToday
{
    //On récupère le jour d'aujourd'hui et on positionne bien le bouton
    NSString *currentDay = [[DDManagerSingleton instance] currentDate];
    
    //On met à jour le singleton pour la date sélectionnée
    [[DDManagerSingleton instance] setCurrentDateSelected:[NSDate date]];
    
    //On récupère l'index du jour dans le tableau de la semaine. On l'incrémente de 1 car Le premier tag des boutons est 1
    [self setDaySelected:[NSString stringWithFormat:@"%i",(int)[[[DDManagerSingleton instance] arrayWeek] indexOfObject:currentDay]]];
}


#pragma mark - DDEventInfosViewController Functions

//On met à jour les composants en fonction de l'event choisi
- (void)updateComponentWithEventSelected
{
    //On met à jour les notifications
    [self updateNotifications];
    
    //On met à jour les composants
    [self updateComponent];
}

//On ajoute un event
- (void)addEvent
{
    [self onPushAddEventButton:nil];
}

//On appuie sur le bouton pour modifier un évènement
- (void)updateEvent
{
    //On configure le controller
    [self.eventManagerViewController setIsModifyEvent:YES];
    [self.eventManagerViewController setEventToModify:self.eventInfosViewController.currentEvent];
    [self.eventManagerViewController setTask:self.eventInfosViewController.currentEvent.achievement.task];
    [[self.eventManagerViewController arrayOccurence] removeAllObjects];
    [[self.eventManagerViewController arrayOccurence] addObject:[[[DDManagerSingleton instance] arrayWeek]  objectAtIndex:self.eventInfosViewController.currentEvent.day.intValue]];
    [self.eventManagerViewController initiateComponent];
    
    //On ouvre la popUp
    [self openEventManagerViewController];
}


#pragma mark - DDEventManagerViewController Functions

- (void)closeEventManagerView
{
    //On met à jour les notifications
    [self updateNotifications];
    
    //On enlève la popUp
    [self.popOverViewController hide];
    
    //On met l'ancien évènement sélectionné à nil pour pouvoir rafraichir la sélection de la tableView
    self.eventInfosViewController.currentEvent = nil;
    
    //On rafraichi la vue
    [self updateComponent];
}

@end
