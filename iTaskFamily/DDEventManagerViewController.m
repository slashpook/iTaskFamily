//
//  DDEventManagerViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 20/02/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDEventManagerViewController.h"
#import "Event.h"
#import "Task.h"

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
    [[self labelTacheTitre] setFont:POLICE_EVENT_CELL];
    [[self labelTacheTitre] setTextColor:COULEUR_BLACK];
    [[self labelTacheContent] setFont:POLICE_EVENT_CELL];
    [[self labelTacheContent] setTextColor:COULEUR_BLACK];
    [[self labelDateTitre] setFont:POLICE_EVENT_CELL];
    [[self labelDateTitre] setTextColor:COULEUR_BLACK];
    [[self labelDateContent] setFont:POLICE_EVENT_CELL];
    [[self labelDateContent] setTextColor:COULEUR_BLACK];
    [[self labelRecurrence] setFont:POLICE_EVENT_CELL];
    [[self labelRecurrence] setTextColor:COULEUR_BLACK];
    [[self textViewComment] setFont:POLICE_EVENT_CELL];
    [[self textViewComment] setTextColor:COULEUR_BLACK];
    
    //On configure la couleur de teinte des switchs
    [self.switchRecurrence setOnTintColor:COULEUR_HOME];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableViewElement reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Controller fonctions

//On met à jour les composants
- (void)updateComponent
{
    //Suivant si on ajoute ou modifie les données, on configure les composants
    if ([self isModifyEvent] == NO)
    {
        [self.custoNavBar.imageViewBackground setImage:[UIImage imageNamed:@"TaskButtonNavigationBarAdd"]];
        [self.labelTacheContent setText:self.task.name];
        [self.labelDateContent setText:[self formatOccurence]];
        [self.switchRecurrence setOn:YES];
        [self.textViewComment setText:@""];
    }
    else
    {
        [self.custoNavBar.imageViewBackground setImage:[UIImage imageNamed:@"TaskButtonNavigationBarAdd"]];
        [self.labelTacheContent setText:self.event.task.name];
        [self.labelDateContent setText:self.event.day];
        [self.switchRecurrence setOn:[self.event.recurrence boolValue]];
        [self.textViewComment setText:self.event.comment];
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

#pragma mark - Keyboard fonctions

//Fonction appelé lorsque l'on commence l'édition d'un champs
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UP_POPOVER" object:[NSNumber numberWithInteger:220]];
}

//Fonction appelé lorsqu'on l'on termine l'édition d'un champs
- (void)keyboardDidHide:(NSNotification *)notif
{
    //On redescend la vue
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UP_POPOVER" object:[NSNumber numberWithInteger:0]];
}


#pragma mark Delegate Table View


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch (indexPath.row)
    {
        case 0:
            cell = self.cell1;
            break;
        case 1:
        {
            cell = self.cell2;
            break;
        }
        case 2:
            cell = self.cell3;
    }
    
    return cell;
}

//On sélectionne la cellule
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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


#pragma mark Fonctions de DDOccurenceViewProtocol

-(void)saveOccurencewithArray:(NSMutableArray *)arrayOccurence
{
    //On met à jour le tableau des jours sélectionnés
    [self setArrayOccurence:arrayOccurence];
    
    //On met à jour les composants
    [self updateComponent];
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
