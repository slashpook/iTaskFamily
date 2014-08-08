//
//  DDCustomImagePickerViewController
//  ITaskFamily
//
//  Created by DAMIEN DELES on 04/04/12.
//  Copyright (c) 2012 INGESUP. All rights reserved.
//

#import "DDCustomImagePickerViewController.h"
#import "DDCustomCollectionViewCell.h"

@interface DDCustomImagePickerViewController ()

@end

@implementation DDCustomImagePickerViewController


#pragma mark - Fonctions de base

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {
        _assets = [[NSMutableArray alloc] init];
        _arrayImage = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
    
    //On initialise la navigation bar
    _custoNavBar = [[DDCustomNavigationBarController alloc] initWithDelegate:self andTitle:@"" andBackgroundColor:COULEUR_PLAYER andImage:[UIImage imageNamed:@"PlayerButtonLibraryNavBar"]];
    [[self.custoNavBar view] setFrame:CGRectMake(0, 0, 380, 50)];
    [[self.custoNavBar buttonLeft] setTitle:@"Retour" forState:UIControlStateNormal];
    [[self.custoNavBar buttonRight] setHidden:YES];
    [self.view addSubview:self.custoNavBar.view];
    
    //On s'abonne a un type de cellule
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
}

- (void)viewDidUnload
{
    
}

- (void)viewWillAppear:(BOOL)animated
{    
    [[self collectionView] reloadData];
}


#pragma mark - Controller fonctions

//On charge les images
- (void)loadImages
{
    [self.arrayImage removeAllObjects];

    //On boucle pour remplir le tableau d'image
    for (int i = 0; i < self.assets.count; i++)
    {
        [self.arrayImage addObject:[NSNull null]];
    }
}

//On sélectionne une image
- (IBAction)onPushImage:(id)sender
{
    UIButton *button = (UIButton *)sender;
	self.selectedImage = [UIImage imageWithCGImage:[[[self.assets objectAtIndex:button.tag] defaultRepresentation] fullScreenImage]];
    [self.navigationController popViewControllerAnimated:true];
}


#pragma mark - UICollectionViewDelegate functions

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [self.assets count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //On récupère la cellule
    DDCustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    //On met un background blanc par défaut
    [cell.imageViewPhoto setImage:nil];
    [cell.imageViewPhoto setBackgroundColor:COULEUR_WHITE];
    
    //On rentre l'image
    dispatch_async(dispatch_get_main_queue(), ^{
        //On crée l'image
        UIImage *image;
        
        //On vérifie si l'image existe déjà ou non
        if ([self.arrayImage objectAtIndex:indexPath.row] == [NSNull null])
        {
            //Load the image from the path
            image = [UIImage imageWithCGImage:[[self.assets objectAtIndex:indexPath.row] aspectRatioThumbnail]];
            image  = [image imageByScalingAndCroppingForSize:CGSizeMake(200, 200)];
            if (image != nil)
            {
                //On met à jour le tableau d'image
                [self.arrayImage replaceObjectAtIndex:indexPath.row withObject:image];
            }
        }
        else
        {
            image = [self.arrayImage objectAtIndex:indexPath.row];
        }
        
        //On affiche l'image
        [cell.imageViewPhoto setImage:image];
    });
    
    return cell;
}


//On sélectionne la cellule
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	self.selectedImage = [UIImage imageWithCGImage:[[[self.assets objectAtIndex:indexPath.row] defaultRepresentation] fullScreenImage]];
    [self.navigationController popViewControllerAnimated:true];
}


#pragma mark CustoNavigationBar fonctions

//On appuie sur le bouton de retour
-(void)onPushLeftBarButton
{
    [self.navigationController popViewControllerAnimated:true];
}

@end
