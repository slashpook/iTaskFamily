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
    
    //On récupère le jour d'aujourd'hui et on positionne bien le bouton
    NSString *currentDay = [[DDManagerSingleton instance] currentDate];
    //On récupère l'index du jour dans le tableau de la semaine. On l'incrémente de 1 car Le premier tag des boutons est 1
    [self setDaySelected:[NSString stringWithFormat:@"%i",(int)[[[DDManagerSingleton instance] arrayWeek] indexOfObject:currentDay]]];
    
    //On rafraichis les composants
    [self updateComponent];
}


#pragma mark - View fonctions

//On met à jour les composants en fonctions des joueurs
- (void)updateComponent
{
    //On récupère le joueur courant
    Player *currentPlayer = [[DDManagerSingleton instance] currentPlayer];
    
    [self.eventInfosViewController.view setHidden:YES];
    [self.imageViewPlus setHidden:NO];
    
    //si le joueur n'existe pas on désactive les boutons
    if (currentPlayer == nil)
    {
        [self.buttonAddPlayer setHidden:NO];
        [self.buttonBigAddEvent setHidden:YES];
        [[self constraintPostionXImagePlus] setConstant:310];
    }
    //Sinon on vérifie qu'il y a des évènements
    else
    {
        [self.buttonAddPlayer setHidden:YES];
        [self.buttonBigAddEvent setHidden:YES];
        [self.eventInfosViewController.buttonDeleteEvent setEnabled:YES];
        [self.eventInfosViewController.buttonModifyEvent setEnabled:YES];

        //Si il n'y a pas d'évènement on désactive certains boutons.
        if ([[[DDDatabaseAccess instance] getEventsForPlayer:currentPlayer atWeekAndYear:[DDHelperController getWeekAndYear] andDay:self.daySelected] count] > 0)
        {
            [self.imageViewPlus setHidden:YES];
            [self.eventInfosViewController.view setHidden:NO];
            [self.eventInfosViewController getEventsForDay:self.daySelected];
            //Si on a fini la tache sélectionnée, on désactive le bouton pour modifier l'évènement
            if ([self.eventInfosViewController.currentEvent.checked boolValue] == YES)
                [[self.eventInfosViewController buttonModifyEvent] setEnabled:NO];
        }
        else
        {
            [[self constraintPostionXImagePlus] setConstant:260];
            [self.buttonBigAddEvent setHidden:NO];
        }
    }
    
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
        
        //On récupère le compteur
        int compteur = [[DDDatabaseAccess instance] getNumberOfEventUncheckedForPlayer:[[DDManagerSingleton instance] currentPlayer] forWeekAndYear:[DDHelperController getWeekAndYear] andDay:dayOfNotification];
        
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
    [self setDaySelected:[NSString stringWithFormat:@"%i", daySelectedInNumber]];
    
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
    [self.eventManagerViewController updateComponent];
    
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
    [[self.eventManagerViewController arrayOccurence] removeAllObjects];
    [[self.eventManagerViewController arrayOccurence] addObject:[[[DDManagerSingleton instance] arrayWeek]  objectAtIndex:self.eventInfosViewController.currentEvent.day.intValue]];
    [self.eventManagerViewController updateComponent];
    
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
