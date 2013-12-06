//
//  DDCustomImagePickerViewController
//  ITaskFamily
//
//  Created by DAMIEN DELES on 04/04/12.
//  Copyright (c) 2012 INGESUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+CustomImage.h"
#import "DDCustomNavigationBarController.h"

@interface DDCustomImagePickerViewController : UIViewController <DDCustomNavBarProtocol, UICollectionViewDataSource, UICollectionViewDelegate>
{
	NSMutableArray *_images;
	NSMutableArray *_thumbs;
	UIImage *_selectedImage;
}


#pragma mark - Variables

//Navigation bar
@property (strong, nonatomic) DDCustomNavigationBarController *custoNavBar;

//Tableau des images
@property (strong, nonatomic) NSMutableArray *assets;

//Image sélectionnée
@property (strong, nonatomic) UIImage *selectedImage;

//Compteur pour enlever la vue de chargement
@property (assign, nonatomic) int compteur;

//Collection des images
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//Tableau des images
@property (strong, nonatomic) NSMutableArray *arrayImage;


#pragma mark - Fonctions

//On charge les images
- (void)loadImages;


@end
