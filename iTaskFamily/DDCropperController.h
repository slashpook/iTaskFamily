//
//  DDCropperController.h
//  ITaskFamily
//
//  Created by DAMIEN DELES on 03/05/12.
//  Copyright (c) 2012 INGESUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDImageCropper.h"

@protocol DDCropperProtocol <NSObject>

//On valide l'image
- (void)validImage:(UIImage *)imageCropped;

//On annule l'image
- (void)cancelImage;

@end

@interface DDCropperController : UIViewController


#pragma mark - Variables

//Image cropper
@property (strong, nonatomic) DDImageCropper *imageCropper;

//Delegate de la vue
@property (weak, nonatomic) id<DDCropperProtocol> delegate;

//Image view pour la préview
@property (strong, nonatomic) UIImageView *preview;

//Image pour le crop
@property (strong, nonatomic) UIImage *imageToCrop;

//Bouton de validation
@property (weak, nonatomic) IBOutlet UIButton *buttonValider;

//Bouton d'annulation
@property (weak, nonatomic) IBOutlet UIButton *buttonAnnuler;

//Label titre
@property (weak, nonatomic) IBOutlet UILabel *labelRedimensionner;


#pragma mark - Fonctions

//On charge les données
- (id)initWithImage:(UIImage *)imageToCrop andDelegate:(id<DDCropperProtocol>)delegate;

//On appuie sur le bouton annulé
- (IBAction)onPushAnnuler:(id)sender;

//On appuie sur le bouton validé
- (IBAction)onPushValider:(id)sender;

@end
