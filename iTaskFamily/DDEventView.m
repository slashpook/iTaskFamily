//
//  DDEventView.m
//  iTaskFamily
//
//  Created by Damien DELES on 24/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDEventView.h"
#import "DDPopOverViewController.h"
#import "Player.h"
#import "Event.h"

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
    [self.labelInfos setTextColor:COULEUR_BLACK];
    [self.labelInfos setFont:POLICE_EVENT_NO_PLAYER];
    [[self.buttonLundi titleLabel] setTextColor:COULEUR_WHITE];
    [[self.buttonLundi titleLabel] setFont:POLICE_EVENT_DAY];
    [[self.buttonMardi titleLabel] setTextColor:COULEUR_WHITE];
    [[self.buttonMardi titleLabel] setFont:POLICE_EVENT_DAY];
    [[self.buttonMercredi titleLabel] setTextColor:COULEUR_WHITE];
    [[self.buttonMercredi titleLabel] setFont:POLICE_EVENT_DAY];
    [[self.buttonJeudi titleLabel] setTextColor:COULEUR_WHITE];
    [[self.buttonJeudi titleLabel] setFont:POLICE_EVENT_DAY];
    [[self.buttonVendredi titleLabel] setTextColor:COULEUR_WHITE];
    [[self.buttonVendredi titleLabel] setFont:POLICE_EVENT_DAY];
    [[self.buttonSamedi titleLabel] setTextColor:COULEUR_WHITE];
    [[self.buttonSamedi titleLabel] setFont:POLICE_EVENT_DAY];
    [[self.buttonDimanche titleLabel] setTextColor:COULEUR_WHITE];
    [[self.buttonDimanche titleLabel] setFont:POLICE_EVENT_DAY];
    
    //On met les images en couleurs
    [self.imageViewHeader setBackgroundColor:COULEUR_BLACK];
    
    //On récupère le storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //On initialise le popOver, le navigation controller et le playerManagerViewController
    _popOverViewController = [storyboard instantiateViewControllerWithIdentifier:@"PopOverViewController"];
    _eventManagerViewController = [storyboard instantiateViewControllerWithIdentifier:@"EventManagerViewController"];
    [self.eventManagerViewController setDelegate:self];
    _navigationEventManagerViewController = [[UINavigationController alloc] initWithRootViewController:self.eventManagerViewController];
    
    //On récupère le jour d'aujourd'hui et on positionne bien le bouton
    NSString *currentDay = [[DDManagerSingleton instance] currentDate];
    //On récupère l'index du jour dans le tableau de la semaine. On l'incrémente de 1 car Le premier tag des boutons est 1
    [self setDaySelected:[NSString stringWithFormat:@"%i",[[[DDManagerSingleton instance] arrayWeek] indexOfObject:currentDay]]];
    
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
    
    //si le joueur n'existe pas on désactive les boutons
    if (currentPlayer == nil)
    {
        [self.labelInfos setHidden:NO];
        [self.labelInfos setText:@"Aucun joueur"];
        [self.buttonAddEvent setEnabled:NO];
        [self.buttonDeleteEvent setEnabled:NO];
        [self.buttonModifyEvent setEnabled:NO];
    }
    //Sinon on vérifie qu'il y a des évènements
    else
    {
        [self.labelInfos setHidden:YES];
        [self.buttonAddEvent setEnabled:YES];
        [self.buttonDeleteEvent setEnabled:YES];
        [self.buttonModifyEvent setEnabled:YES];
        
        //Si il n'y a pas d'évènement on désactive certains boutons.
        if ([[[DDDatabaseAccess instance] getEventsForPlayer:currentPlayer atDay:self.daySelected] count] > 0)
        {
            [self.eventInfosViewController.view setHidden:NO];
            [self.eventInfosViewController getEventsForDay:self.daySelected];
            
            //Si on a fini la tache sélectionnée, on désactive le bouton pour modifier l'évènement
            if ([self.eventInfosViewController.currentEvent.isFinished boolValue] == YES)
                [[self buttonModifyEvent] setEnabled:NO];
        }
        else
        {
            [self.labelInfos setHidden:NO];
            [self.labelInfos setText:@"Aucun évènement"];
            [self.buttonDeleteEvent setEnabled:NO];
            [self.buttonModifyEvent setEnabled:NO];
        }
    }
}

//On se positionne sur le bon jour
- (void)updatePositionOfSelectedDay
{
    //On met le booléen à NO pour empêcher de lancer l'animation
    [self setMustAnimateSelectionDay:NO];
    [self onPushDayButton:[self viewWithTag:(self.daySelected.intValue +1)]];
}

//On appuie sur un des boutons
- (IBAction)onPushDayButton:(id)sender
{
    //En fonction de l'état du booléen, on lance ou non une animation
    if (self.mustAnimateSelectionDay == YES) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.imageViewSelection setFrame:[(UIButton *)sender frame]];
        }];
    }
    else
    {
        [self.imageViewSelection setFrame:[(UIButton *)sender frame]];
        [self setMustAnimateSelectionDay:YES];
    }
    
    //On met l'évènement courant à nil pour tout remettre à 0 dans la sélection
    [self.eventInfosViewController setCurrentEvent:nil];
    
    //On récupère le tag du bouton et on lui enlève un car la première entrée d'un tableau est 0
    int daySelectedInNumber = ([(UIButton *)sender tag] - 1);
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

//On appuie sur le bouton pour supprimer des évènements
- (IBAction)onPushDeleteEventButon:(id)sender
{
    //On met la table en mode suppression ou non en fonction de son ancien état
    if ([self.eventInfosViewController.tableViewEvents isEditing] == false)
        [self.eventInfosViewController.tableViewEvents setEditing:true animated:true];
    else
        [self.eventInfosViewController.tableViewEvents setEditing:false animated:true];
}

//On appuie sur le bouton pour modifier un évènement
- (IBAction)onPushModifyEventButton:(id)sender
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
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_NOTIFICATION object:nil];
    
    //On met à jour les composants
    [self updateComponent];
}


#pragma mark - DDEventManagerViewController Functions

- (void)closeEventManagerView
{
    //On met à jour les notifications
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_NOTIFICATION object:nil];
    
    //On enlève la popUp
    [self.popOverViewController hide];
    
    //On met l'ancien évènement sélectionné à nil pour pouvoir rafraichir la sélection de la tableView
    self.eventInfosViewController.currentEvent = nil;
    
    //On rafraichi la vue
    [self updateComponent];
}

@end
