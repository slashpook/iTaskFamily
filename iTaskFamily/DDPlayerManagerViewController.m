//
//  DDPlayerManagerViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 26/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDPlayerManagerViewController.h"

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
    [self.textFieldPseudo.layer setCornerRadius:5.0];
    [self.textFieldPseudo.layer setMasksToBounds:YES];
    
    //On rajoute un padding sur le textfield
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.textFieldPseudo.leftView = paddingView;
    self.textFieldPseudo.leftViewMode = UITextFieldViewModeAlways;
    
    //On met en place la barre de navigation
    _custoNavBar = [[DDCustomNavigationBarController alloc] initWithDelegate:self andTitle:@"" andBackgroundColor:[DDHelperController getMainTheme] andImage:[UIImage imageNamed:@"PlayerAddButtonNavBar"]];
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
    
    //On initialise l'imagePickerController
    _imagePickerViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"ImagePickerController"];
    
    //On initialise le cropper controller
    _cropperController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"CropperController"];
    [self.cropperController setDelegate:self];
    
    //On met en place la notification pour mettre à jour le theme
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTheme)
                                                 name:UPDATE_THEME
                                               object:nil];
    
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

//On met à jour le theme
- (void)updateTheme
{
    [self.custoNavBar.view setBackgroundColor:[DDHelperController getMainTheme]];
}

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
    //On met en place le message d'erreur
    NSString *errorMessage = nil;
    
    //Si c'est un nouveau player
    if (self.isModifyPlayer == NO)
    {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
        _player = [[Player alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    }
    
    //On crée le chemin de l'image
    NSArray *defaultPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *imgProfilPath = [defaultPaths objectAtIndex:0];
    imgProfilPath = [imgProfilPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", self.textFieldPseudo.text]];
    
    //On set le pseudo
    [self.player setPseudo:self.textFieldPseudo.text];
    //On configure le path de l'image
    [self.player setPathImage:imgProfilPath];
    
    //Si on ajoute un joueur
    if (self.isModifyPlayer == NO)
    {
        errorMessage = [[DDDatabaseAccess instance] createPlayer:self.player];
        [[DDManagerSingleton instance] saveImgProfilForPlayer:self.player withImage:self.imageViewProfil.image];
    }
    //Si on modifie le joueur
    else
    {
        errorMessage = [[DDDatabaseAccess instance] updatePlayer:self.player];
        [[DDManagerSingleton instance] updateImgProfilForPlayer:self.player WithPath:self.player.pseudo withImage:self.imageViewProfil.image];
    }

    //On gère le résultat
    if (self.isModifyPlayer == NO && errorMessage == nil)
        [DDCustomAlertView displayInfoMessage:@"Joueur enregistré"];
    else if (self.isModifyPlayer == YES && errorMessage == nil)
        [DDCustomAlertView displayInfoMessage:@"Joueur modifié"];
    else
    {
        [DDCustomAlertView displayInfoMessage:errorMessage];
        return;
    }
    
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
    //On sauvegarde le joueur
    [self savePlayer];
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
