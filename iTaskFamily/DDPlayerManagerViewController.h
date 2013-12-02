//
//  DDPlayerManagerViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 26/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDCustomNavigationBarController.h"
#import "DDCustomImagePickerViewController.h"
#import "DDCropperController.h"

@class Player;

@protocol DDPlayerManagerViewProtocol <NSObject>

- (void)closePlayerManagerView;

@end

@interface DDPlayerManagerViewController : UIViewController <UIImagePickerControllerDelegate,
UINavigationControllerDelegate, DDCustomNavBarProtocol, DDCropperProtocol>


#pragma mark - Variables

//Delegate de la vue
@property (strong, nonatomic) id<DDPlayerManagerViewProtocol> delegate;

//Navigation bar
@property (strong, nonatomic) DDCustomNavigationBarController *custoNavBar;

//ImageView du profil
@property (weak, nonatomic) IBOutlet UIImageView *imageViewProfil;

//Bouton de la bibliothèque
@property (weak, nonatomic) IBOutlet UIButton *buttonLibrary;

//Bouton pour prendre une photo
@property (weak, nonatomic) IBOutlet UIButton *buttonPhoto;

//Label pseudo
@property (weak, nonatomic) IBOutlet UILabel *labelPseudo;

//Label photo
@property (weak, nonatomic) IBOutlet UILabel *labelImage;

//TextField pseudo
@property (weak, nonatomic) IBOutlet UITextField *textFieldPseudo;

//Image picker pour récupérer les images de la bibliothèque
@property (strong, nonatomic) DDCustomImagePickerViewController *imagePickerViewController;

//Cropper controller pour redimensionner l'image
@property (strong, nonatomic) DDCropperController *cropperController;

//Booléen pour savoir si on modifie ou ajoute un joueur
@property (assign, nonatomic) BOOL isModifyPlayer;

//Joueur à modifier
@property (strong, nonatomic) Player *player;


#pragma mark - Fonctions

//On ouvre la bibliothèque de l'iPad
- (IBAction)onPushOpenLibrary:(id)sender;

//On ouvre la caméra
- (IBAction)onPushOpenCamera:(id)sender;

//On met à jour les composants
- (void)updateComponent;

@end
