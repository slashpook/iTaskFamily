//
//  DDTaskManagerViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 05/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDTaskManagerViewController.h"
#import "Categories.h"
#import "Task.h"
#import "Player.h"
#import "Realisation.h"

@interface DDTaskManagerViewController ()

@end

@implementation DDTaskManagerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.view setBackgroundColor:COULEUR_BACKGROUND];
    
    //On cache la navigation bar
    [self.navigationController setNavigationBarHidden:YES];
    
    //On configure l'arrondi des vues
    [self.navigationController.view.layer setCornerRadius:10.0];
    [self.navigationController.view.layer setMasksToBounds:YES];
    
    //On met en place la barre de navigation
    _custoNavBar = [[DDCustomNavigationBarController alloc] initWithDelegate:self andTitle:@"" andBackgroundColor:COULEUR_TASK andImage:[UIImage imageNamed:@"TaskButtonNavigationBarAdd"]];
    [[self.custoNavBar view] setFrame:CGRectMake(0, 0, 380, 50)];
    [[self.custoNavBar buttonRight] setTitle:@"Sauver" forState:UIControlStateNormal];
    [[self.custoNavBar buttonLeft] setTitle:@"Annuler" forState:UIControlStateNormal];
    [self.view addSubview:self.custoNavBar.view];
    
    //On set la police et la couleur des label et textfield
    [[self labelInformations] setFont:POLICE_TASK_TITLE];
    [[self labelInformations] setTextColor:COULEUR_BLACK];
    [[self labelObjectifs] setFont:POLICE_TASK_TITLE];
    [[self labelObjectifs] setTextColor:COULEUR_BLACK];
    [[self labelTitleNameTask] setFont:POLICE_TASK_CELL];
    [[self labelTitleNameTask] setTextColor:COULEUR_BLACK];
    [[self textFieldNameTask] setFont:POLICE_TASK_CELL];
    [[self textFieldNameTask] setTextColor:COULEUR_BLACK];
    [[self labelTitleNameCategory] setFont:POLICE_TASK_CELL];
    [[self labelTitleNameCategory] setTextColor:COULEUR_BLACK];
    [[self labelNameCategory] setFont:POLICE_TASK_CELL];
    [[self labelNameCategory] setTextColor:COULEUR_BLACK];
    [[self labelTitlePoint] setFont:POLICE_TASK_CELL];
    [[self labelTitlePoint] setTextColor:COULEUR_BLACK];
    [[self textFieldPoint].layer setCornerRadius:5.0];
    [[self textFieldPoint].layer setMasksToBounds:YES];
    [[self textFieldPoint] setFont:POLICE_TASK_CELL];
    [[self textFieldPoint] setTextColor:COULEUR_BLACK];
    
    //On configure les imageView des réalisations
    [self.textFieldBronze.layer setCornerRadius:5.0];
    [self.textFieldBronze.layer setMasksToBounds:YES];
    [self.textFieldBronze setBackgroundColor:COULEUR_WHITE];
    [self.textFieldBronze setFont:POLICE_TASK_CONTENT];
    [self.textFieldArgent.layer setCornerRadius:5.0];
    [self.textFieldArgent.layer setMasksToBounds:YES];
    [self.textFieldArgent setBackgroundColor:COULEUR_WHITE];
    [self.textFieldArgent setFont:POLICE_TASK_CONTENT];
    [self.textFieldOr.layer setCornerRadius:5.0];
    [self.textFieldOr.layer setMasksToBounds:YES];
    [self.textFieldOr setBackgroundColor:COULEUR_WHITE];
    [self.textFieldOr setFont:POLICE_TASK_CONTENT];
    
    //On récupère le storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //On initialise la liste des categories
    _categorieListViewController = [storyboard instantiateViewControllerWithIdentifier:@"CategorieListViewController"];
    [self.categorieListViewController setDelegate:self];
    [self.categorieListViewController setCouleurBackground:COULEUR_TASK];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableViewTaskInfo reloadData];
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
    if ([self isModifyTask] == NO)
    {
        [self.custoNavBar.imageViewBackground setImage:[UIImage imageNamed:@"TaskButtonNavigationBarAdd"]];
        [self.textFieldNameTask setText:@""];
        [self.labelNameCategory setText:self.currentCategory.name];
        [self.textFieldPoint setText:@""];
        [self.textFieldBronze setText:@""];
        [self.textFieldArgent setText:@""];
        [self.textFieldOr setText:@""];
    }
    else
    {
        [self.custoNavBar.imageViewBackground setImage:[UIImage imageNamed:@"TaskButtonNavigationBarAdd"]];
        [self.textFieldNameTask setText:self.task.name];
        [self.labelNameCategory setText:self.currentCategory.name];
        [self.textFieldPoint setText:[NSString stringWithFormat:@"%i",self.task.point.intValue]];
        
        //On boucle sur les réalisations de la tache pour les mettres à jour
        for (Realisation *realisation in self.task.realisation)
        {
            if ([realisation.type isEqualToString:@"Bronze"])
                [self.textFieldBronze setText:[NSString stringWithFormat:@"%i", realisation.total.intValue]];
            else if ([realisation.type isEqualToString:@"Argent"])
                [self.textFieldArgent setText:[NSString stringWithFormat:@"%i", realisation.total.intValue]];
            else
                [self.textFieldOr setText:[NSString stringWithFormat:@"%i", realisation.total.intValue]];
        }
    }
}

//Teste si tous les champs sont remplies
- (Boolean)isFieldsEmpty
{
    if (self.currentCategory != nil && [[self.textFieldNameTask text] length] != 0 && [self.textFieldPoint.text length] != 0 && [self.textFieldBronze.text length] != 0 &&  [self.textFieldArgent.text length] != 0 && [self.textFieldOr.text length] != 0)
        return NO;
    else
        return YES;
}

//On teste si le texte rentré est un chiffre
- (BOOL)textIsNumeric
{
    if ([[self.textFieldPoint text] rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound && [[self.textFieldBronze text] rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound && [[self.textFieldArgent text] rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound && [[self.textFieldOr text] rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound)
        return YES;
    else
        return NO;
}

//On vérifie que les occurences des trophées soit plus grande que 0
- (BOOL)occurenceDifferentFromZero
{
    if ([[self.textFieldBronze text] integerValue] == 0 || [[self.textFieldArgent text] integerValue] == 0 || [[self.textFieldOr text] integerValue] == 0)
        return false;
    else
        return true;
}

//Sauvegarder la tache
- (void)saveTask
{
    //Si c'est une nouvelle tache
    if (self.isModifyTask == false)
    {
        //On crée une nouvelle tache
        self.task = [NSEntityDescription
                       insertNewObjectForEntityForName:@"Task"
                       inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
        
        //On set le nom et le point des taches
        [self.task setName:self.textFieldNameTask.text];
        [self.task setPoint:[NSNumber numberWithInt:self.textFieldPoint.text.intValue]];

        //On crée les trophées
        Realisation *realisationBronze = [NSEntityDescription
                                           insertNewObjectForEntityForName:@"Realisation"
                                           inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
        [realisationBronze setType:@"Bronze"];
        [realisationBronze setTotal:[NSNumber numberWithInt:self.textFieldBronze.text.intValue]];
        
        Realisation *realisationArgent = [NSEntityDescription
                                          insertNewObjectForEntityForName:@"Realisation"
                                          inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
        [realisationArgent setType:@"Argent"];
        [realisationArgent setTotal:[NSNumber numberWithInt:self.textFieldArgent.text.intValue]];
        
        Realisation *realisationOr = [NSEntityDescription
                                          insertNewObjectForEntityForName:@"Realisation"
                                          inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
        [realisationOr setType:@"Or"];
        [realisationOr setTotal:[NSNumber numberWithInt:self.textFieldOr.text.intValue]];
        
        //On set les réalisation
        [self.task setRealisation:[NSSet setWithObjects:realisationBronze, realisationArgent, realisationOr, nil]];
        
        //On ajoute notre objet au tableau et on le sauvegarde
        NSMutableArray *arrayTaskCategory = [NSMutableArray arrayWithArray:[[self.currentCategory task] allObjects]];
        [arrayTaskCategory addObject:self.task];
        [self.currentCategory setTask:[NSSet setWithArray:arrayTaskCategory]];
        
        //On ajoute la tache aux joueus
        for (Player *player in [[DDDatabaseAccess instance] getPlayers])
        {
            //On ajoute notre objet au tableau et on le sauvegarde
            NSMutableArray *arrayTaskCategory = [NSMutableArray arrayWithArray:[[player task] allObjects]];
            [arrayTaskCategory addObject:self.task];
            [player setTask:[NSSet setWithArray:arrayTaskCategory]];
        }
        
        [DDCustomAlertView displayInfoMessage:@"Tache enregistrée"];
    }
    else
    {
        //On garde une référence de l'ancien nom de la tache
        NSString *oldTaskName = self.task.name;
        
        //On boucle sur les réalisations de la tache pour les mettres à jour
        for (Realisation *realisation in self.task.realisation)
        {
            if ([realisation.type isEqualToString:@"Bronze"])
                [realisation setTotal:[NSNumber numberWithInt:self.textFieldBronze.text.intValue]];
            else if ([realisation.type isEqualToString:@"Argent"])
                [realisation setTotal:[NSNumber numberWithInt:self.textFieldArgent.text.intValue]];
            else
                [realisation setTotal:[NSNumber numberWithInt:self.textFieldOr.text.intValue]];
        }
        
//        //On met à jour la tache si le joueur l'a implémenté dans un event
//        if ([self.playerController countOfPlayers] > 0)
//        {
//            for (Player *player in [self.playerController getPlayersArray])
//            {
//                //On change la tache
//                for (Event *event in [[player eventArray] eventArray])
//                {
//                    if ([event.task.name isEqualToString:self.nameOfTaskToModify] == true)
//                    {
//                        //On met à jour les éléments
//                        [[event task] setName:task.name];
//                        [[event task] setCategory:task.category];
//                        [[event task] setPoint:task.point];
//                        
//                        //Si l'événement était déjà validé, on remet le score avec les bons points
//                        if (event.isFinished == true)
//                        {
//                            int scoreSemaine = (([player.scoreSemaine intValue] - [oldTask.point intValue]) + [task.point intValue]);
//                            int scoreSemainePrecedente = (([player.scoreSemainePrecedente intValue] - [oldTask.point intValue]) + [task.point intValue]);
//                            int scoreTotal = (([player.scoreTotal intValue] - [oldTask.point intValue]) + [task.point intValue]);
//                            
//                            //On regarde si on est sur la semaine passé ou la semaine actuelle pour modifier la bonne semaine
//                            //Semaine en cours
//                            if ([[[DataManager instance] arrayDayActualWeek] containsObject:event.occurence] == true)
//                                [player setScoreSemaine:[NSNumber numberWithInt:scoreSemaine]];
//                            //Semaine précédente
//                            else if ([[[DataManager instance] arrayDayActualWeek] containsObject:event.occurence] == true)
//                                [player setScoreSemainePrecedente:[NSNumber numberWithInt:scoreSemainePrecedente]];
//                            
//                            [player setScoreTotal:[NSNumber numberWithInt:scoreTotal]];
//                        }
//                    }
//                }
//            }
//        }
    
        [DDCustomAlertView displayInfoMessage:@"Tache modifiée. Les points attribués par les évènements de cette tache non validée seront mis à jour et modifiront le score de la semaine en cours et la semaine passée"];
    }
    
    //On sauvegarde le joueur
    [[DDDatabaseAccess instance] saveContext:nil];
   
    [self.delegate closeTaskManagerView];
}


#pragma mark Delegate Table View


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
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
            [self.labelNameCategory setText:self.currentCategory.name];
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
    if (indexPath.row == 1)
    {
        //On push la vue dans le navigation controller
        [self.navigationController pushViewController:self.categorieListViewController animated:YES];
    }
}


#pragma mark Fonctions de UITextViewDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UP_POPOVER" object:[NSNumber numberWithBool:true]];
    return true;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UP_POPOVER" object:[NSNumber numberWithBool:false]];
    return true;
}


#pragma mark - NavigationBar fonctions

//On appuie sur le bouton de gauche
- (void)onPushLeftBarButton
{
    //On ferme la vue
    [self.delegate closeTaskManagerView];
}

//On appuie sue le bouton de droite
- (void)onPushRightBarButton
{
    //Si tout les champs sont remplis
    if ([self isFieldsEmpty] == false)
    {
        //Si les textes numériques le sont
        if ([self textIsNumeric] == true)
        {
            //On vérifie que l'on a des occurences supérieures à 0
            if ([self occurenceDifferentFromZero] == true)
            {
                //Si on crée une nouvelle tache
                if (self.isModifyTask == false)
                {
                    //On fait les tests sur la tache
                    if ([[DDDatabaseAccess instance] taskExistWithName:self.textFieldNameTask.text] == YES)
                    {
                        [DDCustomAlertView displayErrorMessage:@"Une autre tache porte déjà ce nom!"];
                        return;
                    }
                    
                    //On fait toutes les sauvegardes nécessaires
                    [self saveTask];
//                    [self saveTropheesWithOccurTask:self.txtOccurenceBronze.text andType:@"Bronze"];
//                    [self saveTropheesWithOccurTask:self.txtOccurenceArgent.text andType:@"Argent"];
//                    [self saveTropheesWithOccurTask:self.txtOccurenceOr.text andType:@"Or"];
                }
                //Sinon on modifie la tache
                else
                {
                    //On fait les tests sur la tache
                    if ([[DDDatabaseAccess instance] taskExistWithName:self.textFieldNameTask.text] == YES && [self.task.name isEqualToString:self.textFieldNameTask.text] == NO)
                    {
                        [DDCustomAlertView displayErrorMessage:@"Une autre tache porte déjà ce nom!"];
                        return;
                    }
                    
                    //On fait toutes les sauvegardes nécessaires
                    [self saveTask];
//                    [self saveTropheesWithOccurTask:self.txtOccurenceBronze.text andType:@"Bronze"];
//                    [self saveTropheesWithOccurTask:self.txtOccurenceArgent.text andType:@"Argent"];
//                    [self saveTropheesWithOccurTask:self.txtOccurenceOr.text andType:@"Or"];
                }
                
//                //On met à jour les trophées
//                if ([self.playerController countOfPlayers] > 0)
//                {
//                    for (int i = 0; i < [self.playerController countOfPlayers]; i++)
//                        [[self.playerController getPlayerAtIndex:i] setTropheesTotalRealised:[NSNumber numberWithInt:[self.playerController getNumberOfValidTropheesForPlayer:[[self.playerController getPlayerAtIndex:i] pseudo]]]];
//                }
                
                [self.delegate closeTaskManagerView];
            }
            else
                [DDCustomAlertView displayErrorMessage:@"Veuillez rentrer des objectifs supérieurs à 0"];
        }
        else
            [DDCustomAlertView displayErrorMessage:@"Veuillez ne rentrer que des chiffres pour les points et les objectifs"];
    }
    else
        [DDCustomAlertView displayErrorMessage:@"Veuillez remplir tous les champs svp !"];
}


#pragma mark - DDCategorieViewProtocol fonction

- (void)closeCategorieViewWithCategorie:(Categories *)categorie
{
    //On met à jour la catégorie en cours et on change le texte
    [self setCurrentCategory:categorie];
    [self.labelNameCategory setText:categorie.name];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
