//
//  DDPlayerManagerViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 26/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDPlayerManagerViewController.h"
#import "Player.h"

@interface DDPlayerManagerViewController ()

@end

@implementation DDPlayerManagerViewController


#pragma mark - Fonctions de base

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
    [self.imageViewProfil.layer setCornerRadius:10.0];
    [self.imageViewProfil.layer setMasksToBounds:YES];
    [self.buttonLibrary.layer setCornerRadius:10.0];
    [self.buttonLibrary.layer setMasksToBounds:YES];
    [self.buttonPhoto.layer setCornerRadius:10.0];
    [self.buttonPhoto.layer setMasksToBounds:YES];
    [self.textFieldPseudo.layer setCornerRadius:10.0];
    [self.textFieldPseudo.layer setMasksToBounds:YES];
    
    //On rajoute un padding sur le textfield
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.textFieldPseudo.leftView = paddingView;
    self.textFieldPseudo.leftViewMode = UITextFieldViewModeAlways;
    
    //On met en place la barre de navigation
    _custoNavBar = [[DDCustomNavigationBarController alloc] initWithDelegate:self andTitle:@"" andBackgroundColor:COULEUR_PLAYER andImage:[UIImage imageNamed:@"PlayerAddButtonNavBar"]];
    [[self.custoNavBar view] setFrame:CGRectMake(0, 0, 380, 50)];
    [[self.custoNavBar buttonRight] setTitle:@"Sauver" forState:UIControlStateNormal];
    [[self.custoNavBar buttonLeft] setTitle:@"Annuler" forState:UIControlStateNormal];
    [self.view addSubview:self.custoNavBar.view];
    
    //On set la police et la couleur des label et textfield
    [[self labelPseudo] setFont:POLICE_PLAYER_TITLE];
    [[self labelPseudo] setTextColor:COULEUR_BLACK];
    [[self labelImage] setFont:POLICE_PLAYER_TITLE];
    [[self labelImage] setTextColor:COULEUR_BLACK];
    [[self textFieldPseudo] setFont:POLICE_PLAYER_CONTENT];
    [[self textFieldPseudo] setTextColor:COULEUR_BLACK];
    
    //On récupère le storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //On initialise l'imagePickerController
    _imagePickerViewController = [storyboard instantiateViewControllerWithIdentifier:@"ImagePickerController"];
    
    //On initialise le cropper controller
    _cropperController = [storyboard instantiateViewControllerWithIdentifier:@"CropperController"];
    [self.cropperController setDelegate:self];
    
    [self updateComponent];
}

- (void)viewWillAppear:(BOOL)animated
{
    //Si on a récupéré une image dans la bibliothèque, on la croppe
    if ([self.imagePickerViewController selectedImage] != NULL)
    {
        [self cropImage:self.imagePickerViewController.selectedImage];
        [self.imagePickerViewController setSelectedImage:NULL];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Controller fonctions


//On ouvre la bibliothèque de l'iPad
- (IBAction)onPushOpenLibrary:(id)sender
{
    //On push la vue dans le navigation controller
    [self.navigationController pushViewController:self.imagePickerViewController animated:YES];
}

//On ouvre la caméra
- (IBAction)onPushOpenCamera:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        //On configure la caméra
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker.view setFrame:[UIScreen mainScreen].bounds];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = NO;
        
        //On cache la barre de statue
        [self presentViewController:imagePicker animated:YES completion:NO];
    }
}

//On met à jour les composants
- (void)updateComponent
{
    //On charge les images de la bibliothèque
    [self loadImagePicker];
    
    //Suivant si on ajoute ou modifie les données, on configure les composants
    if ([self isModifyPlayer] == NO)
    {
        [self.custoNavBar.imageViewBackground setImage:[UIImage imageNamed:@"PlayerAddButtonNavBar"]];
        [self.textFieldPseudo setText:@""];
        [self.imageViewProfil setImage:[UIImage imageNamed:@"PlayerManageProfil"]];
    }
    else
    {
        [self.custoNavBar.imageViewBackground setImage:[UIImage imageNamed:@"PlayerEditButtonNavBar"]];
        [self.textFieldPseudo setText:self.player.pseudo];
        [self.imageViewProfil setImage:[[[DDManagerSingleton instance] dictImagePlayer] objectForKey:self.player.pseudo]];
    }
}

//On recharge les images du picker
- (void)loadImagePicker
{
    [self.imagePickerViewController setAssets:[[DDManagerSingleton instance] arrayImagePicker]];
    [self.imagePickerViewController loadImages];
}

//On croppe l'image
- (void)cropImage:(UIImage *)image
{
    //On initialise le cropperController
    [[self cropperController] setImageToCrop:image];
    [[[[[[UIApplication sharedApplication] delegate] window] rootViewController] view] addSubview:self.cropperController.view];
}

//On sauvegarde le joueur
- (void)savePlayer
{
    //On crée le chemin de l'image
    NSArray *defaultPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *imgProfilPath = [defaultPaths objectAtIndex:0];
    imgProfilPath = [imgProfilPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", self.textFieldPseudo.text]];

    //Si on ajoute un joueur
    if (self.isModifyPlayer == NO)
    {
        //On crée un nouveau joueur
        self.player = [NSEntityDescription
                      insertNewObjectForEntityForName:@"Player"
                      inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
        
            [self.player setPseudo:self.textFieldPseudo.text];
        [[DDManagerSingleton instance] saveImgProfilForPlayer:self.player withImage:self.imageViewProfil.image];
        //On affiche une alertView pour indiquer que le joueur a bien été ajouté
        [DDCustomAlertView displayInfoMessage:@"Joueur enregistré"];
    }
    //Si on modifie le joueur
    else
    {
        [self.player setPseudo:self.textFieldPseudo.text];
        [[DDManagerSingleton instance] updateImgProfilForPlayer:self.player WithPath:self.player.pseudo withImage:self.imageViewProfil.image];
        //On affiche une alertView pour indiquer que le joueur a bien été modifié
        [DDCustomAlertView displayInfoMessage:@"Joueur modifié"];
    }

    //On configure le path de l'image
    [self.player setPathImage:imgProfilPath];
    
    //On sauvegarde le joueur
    [[DDDatabaseAccess instance] saveContext:nil];
    
    //On ferme la vue
    [self.delegate closePlayerManagerView];
}


#pragma mark - NavigationBar fonctions

//On appuie sur le bouton de gauche
- (void)onPushLeftBarButton
{
    //On ferme la vue
    [self.delegate closePlayerManagerView];
}

//On appuie sue le bouton de droite
- (void)onPushRightBarButton
{
    //On vérifie que un pseudo soit rentré
    if ([self.textFieldPseudo.text length] != 0)
    {
        //Si on ajoute le joueur
        if (self.isModifyPlayer == false)
        {
            //Si le pseudo n'existe pas déjà
            if ([[DDDatabaseAccess instance] playerExistForPseudo:self.textFieldPseudo.text] == false)
            {
                //On sauvegarde le joueur
                [self savePlayer];
            }
            else
            {
                //On affiche un message d'erreur
                [DDCustomAlertView displayErrorMessage:@"Un autre joueur porte déjà ce nom !"];
            }
        }
        //Si on modifie le joueur
        else
        {
            if (([[DDDatabaseAccess instance] playerExistForPseudo:self.textFieldPseudo.text]) || ([[DDDatabaseAccess instance] playerExistForPseudo:self.textFieldPseudo.text] == true && [self.player.pseudo isEqualToString:self.textFieldPseudo.text] == true))
            {
                //On sauvegarde le joueur
                [self savePlayer];
            }
            else
            {
                //On affiche un message d'erreur
                [DDCustomAlertView displayErrorMessage:@"Un autre joueur porte déjà ce nom!"];
            }
        }
    }
    else
    {
        //On affiche un message d'erreur
        [DDCustomAlertView displayErrorMessage:@"Veuillez rentrer un pseudo svp!"];
    }
}


#pragma mark Fonctions de UIImagePickerViewProtocol

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    //On enlève le picker
    [picker dismissModalViewControllerAnimated:YES];
    
    //On croppe l'image
    [self cropImage:image];
}

//On annule la sélection d'image
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark Fonction de CropperProtocol

//On valide l'image croppée
-(void)validImage:(UIImage *)imageCropped
{
    [self.imageViewProfil setImage:imageCropped];
    [self.cropperController setImageToCrop:NULL];
    [[self.cropperController preview] setImage:NULL];
    [[self.cropperController view] removeFromSuperview];
}

//On annule l'image croppé
-(void)cancelImage
{
    [self.cropperController setImageToCrop:NULL];
    [[self.cropperController preview] setImage:NULL];
    [[self.cropperController view] removeFromSuperview];
}

@end
