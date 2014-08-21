//
//  DDTaskManagerViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 05/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDTaskManagerViewController.h"

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
    _custoNavBar = [[DDCustomNavigationBarController alloc] initWithDelegate:self andTitle:@"" andBackgroundColor:[DDHelperController getMainTheme] andImage:[UIImage imageNamed:@"TaskButtonNavigationBarAdd"]];
    [[self.custoNavBar view] setFrame:CGRectMake(0, 0, 380, 50)];
    [[self.custoNavBar buttonRight] setTitle:@"Sauver" forState:UIControlStateNormal];
    [[self.custoNavBar buttonLeft] setTitle:@"Annuler" forState:UIControlStateNormal];
    [self.view addSubview:self.custoNavBar.view];
    
    //On set la police et la couleur des label et textfield
    [[self labelInformations] setFont:POLICE_TASK_TITLE];
    [[self labelInformations] setTextColor:COULEUR_BLACK];
    [[self labelObjectifs] setFont:POLICE_TASK_TITLE];
    [[self labelObjectifs] setTextColor:COULEUR_BLACK];
    [[self.tableViewTask labelTitleNameTask] setFont:POLICE_TASK_CELL];
    [[self.tableViewTask labelTitleNameTask] setTextColor:COULEUR_BLACK];
    [[self.tableViewTask textFieldNameTask] setFont:POLICE_TASK_CELL];
    [[self.tableViewTask textFieldNameTask] setTextColor:COULEUR_BLACK];
    [[self.tableViewTask labelTitleNameCategory] setFont:POLICE_TASK_CELL];
    [[self.tableViewTask labelTitleNameCategory] setTextColor:COULEUR_BLACK];
    [[self.tableViewTask labelNameCategory] setFont:POLICE_TASK_CELL];
    [[self.tableViewTask labelNameCategory] setTextColor:COULEUR_BLACK];
    [[self.tableViewTask labelTitlePoint] setFont:POLICE_TASK_CELL];
    [[self.tableViewTask labelTitlePoint] setTextColor:COULEUR_BLACK];
    [[self.tableViewTask textFieldPoint].layer setCornerRadius:5.0];
    [[self.tableViewTask textFieldPoint].layer setMasksToBounds:YES];
    [[self.tableViewTask textFieldPoint] setFont:POLICE_TASK_CELL];
    [[self.tableViewTask textFieldPoint] setTextColor:COULEUR_BLACK];
    
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
    
    //On set le delegate aux textFields de la tableView
    [self.tableViewTask.textFieldNameTask setDelegate:self];
    [self.tableViewTask.textFieldPoint setDelegate:self];
    
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableViewTask.labelNameCategory setText:self.currentCategory.libelle];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self setTableViewTask:segue.destinationViewController];
    [self.tableViewTask setDelegate:self];
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
        [self.tableViewTask.textFieldNameTask setText:@""];
        [self.tableViewTask.labelNameCategory setText:self.currentCategory.libelle];
        [self.tableViewTask.textFieldPoint setText:@"0"];
        [self.textFieldBronze setText:@"0"];
        [self.textFieldArgent setText:@"0"];
        [self.textFieldOr setText:@"0"];
    }
    else
    {
        [self.custoNavBar.imageViewBackground setImage:[UIImage imageNamed:@"TaskButtonNavigationBarAdd"]];
        [self.tableViewTask.textFieldNameTask setText:self.task.libelle];
        [self.tableViewTask.labelNameCategory setText:self.currentCategory.libelle];
        [self.tableViewTask.textFieldPoint setText:[NSString stringWithFormat:@"%i",self.task.point.intValue]];
        
        //On boucle sur les réalisations de la tache pour les mettres à jour
        for (Trophy *trophy in [self.task.trophies allObjects])
        {
            if ([trophy.type isEqualToString:@"Bronze"])
                [self.textFieldBronze setText:[NSString stringWithFormat:@"%i", trophy.iteration.intValue]];
            else if ([trophy.type isEqualToString:@"Argent"])
                [self.textFieldArgent setText:[NSString stringWithFormat:@"%i", trophy.iteration.intValue]];
            else
                [self.textFieldOr setText:[NSString stringWithFormat:@"%i", trophy.iteration.intValue]];
        }
    }
}

//On met à jour le theme
- (void)updateTheme
{
    [self.custoNavBar.view setBackgroundColor:[DDHelperController getMainTheme]];
}

//On teste si le texte rentré est un chiffre
- (BOOL)textIsNumeric
{
    if ([[self.tableViewTask.textFieldPoint text] rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound && [[self.textFieldBronze text] rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound && [[self.textFieldArgent text] rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound && [[self.textFieldOr text] rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound)
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
    //On crée ou modifie la task suivant le cas
    if (self.isModifyTask == false)
        [self createTask];
    else
        [self updateTask];
}

//On ajoute la tache
- (void)createTask
{
    //On crée le message d'erreur
    NSString *errorMessage = nil;
    
    //On crée une nouvelle tache
    NSEntityDescription *entityTask = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
    _task = [[Task alloc] initWithEntity:entityTask insertIntoManagedObjectContext:nil];
    
    //On set le nom et le point des taches
    [self.task setLibelle:self.tableViewTask.textFieldNameTask.text];
    [self.task setPoint:[NSNumber numberWithInt:self.tableViewTask.textFieldPoint.text.intValue]];
    
    //On crée les trophies
    NSEntityDescription *entityTrophyBronze = [NSEntityDescription entityForName:@"Trophy" inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
    Trophy *trophyBronze = [[Trophy alloc] initWithEntity:entityTrophyBronze insertIntoManagedObjectContext:nil];
    [trophyBronze setType:@"Bronze"];
    [trophyBronze setIteration:[NSNumber numberWithInt:self.textFieldBronze.text.intValue]];
    
    NSEntityDescription *entityTrophyArgent = [NSEntityDescription entityForName:@"Trophy" inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
    Trophy *trophyArgent = [[Trophy alloc] initWithEntity:entityTrophyArgent insertIntoManagedObjectContext:nil];
    [trophyArgent setType:@"Argent"];
    [trophyArgent setIteration:[NSNumber numberWithInt:self.textFieldArgent.text.intValue]];
    
    NSEntityDescription *entityTrophyOr = [NSEntityDescription entityForName:@"Trophy" inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
    Trophy *trophyOr = [[Trophy alloc] initWithEntity:entityTrophyOr insertIntoManagedObjectContext:nil];
    [trophyOr setType:@"Or"];
    [trophyOr setIteration:[NSNumber numberWithInt:self.textFieldOr.text.intValue]];
    
    //On sauvegarde la task
    errorMessage = [[DDDatabaseAccess instance] createTask:self.task forCategory:self.currentCategory withTrophies:[NSArray arrayWithObjects:trophyBronze, trophyArgent, trophyOr, nil]];
    
    //Si on a pas de message d'erreur on ferme la popUp
    if (errorMessage == nil)
        [DDCustomAlertView displayInfoMessage:@"Tache enregistrée"];
    else
    {
        [DDCustomAlertView displayInfoMessage:errorMessage];
        return;
    }
    
    [self.delegate closeTaskManagerView];
}

//On met la tache à jour
- (void)updateTask
{
    //On crée le message d'erreur
    NSString *errorMessage = nil;
    
    //On met à jour la tache
    [self.task setLibelle:self.tableViewTask.textFieldNameTask.text];
    [self.task setPoint:[NSNumber numberWithInt:[self.tableViewTask.textFieldPoint.text intValue]]];
    [self.task setCategory:self.currentCategory];

    //On boucle sur les réalisations de la tache pour les mettres à jour
    for (Trophy *trophy in [self.task.trophies allObjects])
    {
        if ([trophy.type isEqualToString:@"Bronze"])
            [trophy setIteration:[NSNumber numberWithInt:self.textFieldBronze.text.intValue]];
        else if ([trophy.type isEqualToString:@"Argent"])
            [trophy setIteration:[NSNumber numberWithInt:self.textFieldArgent.text.intValue]];
        else
            [trophy setIteration:[NSNumber numberWithInt:self.textFieldOr.text.intValue]];
    }
    
    [[DDDatabaseAccess instance] updateTask:self.task];
    
    //Si on a pas de message d'erreur on ferme la popUp
    if (errorMessage == nil)
        [DDCustomAlertView displayInfoMessage:@"Tache modifiée"];
    else
    {
        [DDCustomAlertView displayInfoMessage:errorMessage];
        return;
    }
    
    [self.delegate closeTaskManagerView];
}


#pragma mark DDTaskEventTableViewProtocol fonctions


//On sélectionne la cellule
- (void)cellSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
    {
        //On initialise la liste des categories
        DDCategorieListViewController *categorieListViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"CategorieListViewController"];
        [categorieListViewController setDelegate:self];
        [categorieListViewController setCouleurBackground:[DDHelperController getMainTheme]];
        //On push la vue dans le navigation controller
        [self.navigationController pushViewController:categorieListViewController animated:YES];
    }
}


#pragma mark - Keyboard fonctions

//Fonction appelé lorsqu'on l'on termine l'édition d'un champs
- (void)keyboardDidHide:(NSNotification *)notif
{
    //On redescend la vue
    [[NSNotificationCenter defaultCenter] postNotificationName:UP_POPOVER object:[NSNumber numberWithInteger:0]];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UP_POPOVER object:[NSNumber numberWithInteger:220]];
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
    //Si les textes numériques le sont
    if ([self textIsNumeric] == true)
    {
        //On vérifie que l'on a des occurences supérieures à 0
        if ([self occurenceDifferentFromZero] == true)
        {
            //On fait toutes les sauvegardes nécessaires
            [self saveTask];
        }
        else
            [DDCustomAlertView displayErrorMessage:@"Veuillez rentrer des objectifs supérieurs à 0"];
    }
    else
        [DDCustomAlertView displayErrorMessage:@"Veuillez ne rentrer que des chiffres pour les points et les objectifs"];
}


#pragma mark - DDCategorieViewProtocol fonction

- (void)closeCategorieViewWithCategorie:(CategoryTask *)category
{
    //On met à jour la catégorie en cours et on change le texte
    [self setCurrentCategory:category];
    [self.tableViewTask.labelNameCategory setText:category.libelle];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
