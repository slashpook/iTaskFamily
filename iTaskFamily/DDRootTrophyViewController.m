//
//  DDRootTrophyViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 25/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDRootTrophyViewController.h"
#import "DDTrophyRootCell.h"
#import "DDCategoryMiniatureCollectionViewCell.h"
#import "DDMainInformationTrophyViewController.h"

@interface DDRootTrophyViewController ()
{
    NSMutableArray *arrayCategories;
    CategoryTask *category;
}

@end

@implementation DDRootTrophyViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //On récupère le tableau des catégories
        arrayCategories = [[NSMutableArray alloc] initWithArray:[[DDDatabaseAccess instance] getCategoryTasks]];
        category = [arrayCategories objectAtIndex:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //On configure le background de la vue
    [[self view] setBackgroundColor:COULEUR_WHITE];
    
    //On s'abonne a un type de cellule pour la collectionView
    [self.collectionViewMiniature registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CellCollectionView"];
    
    //On ajoute le mainTrophyController à la scrollView
    _mainInformationTrophyViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"MainInformationTrophyViewController"];
    [self.scrollViewGeneral addSubview:[self.mainInformationTrophyViewController view]];
    
    //On met à jour les composants
    [self updateComponent];
}


#pragma mark - Fonctions du controller

//On met à jour la vue
- (void)updateComponent
{
    [self.mainInformationTrophyViewController setCategory:category];
    [self.mainInformationTrophyViewController updateComponent];
    
    [self.pageControl setCurrentPageIndicatorTintColor:[[[DDManagerSingleton instance] dictColor] objectForKey:category.libelle]];
}

#pragma mark - UICollectionViewDelegate functions

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [arrayCategories count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //On récupère le dictionnaire des couleurs des catégories
    NSDictionary *dictColor = [[DDManagerSingleton instance] dictColor];
    
    //On récupère la cellule
    DDCategoryMiniatureCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CategoryMiniatureCell" forIndexPath:indexPath];
    
    //On récupère la category
    CategoryTask *categoryMiniature = [arrayCategories objectAtIndex:indexPath.row];
    
    //On configure l'image du joueur
    [cell.imageViewCategory.layer setCornerRadius:10.0];
    [cell.imageViewCategory setBackgroundColor:[dictColor objectForKey:categoryMiniature.libelle]];
    
    //On configure le label du nom de la catégorie
    [cell.labelName setTextColor:COULEUR_WHITE];
    [cell.labelName setFont:POLICE_CATEGORY_TROPHY_MINIATURE];
    [cell.labelName setText:categoryMiniature.libelle];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //On récupère la categorie
    category = [arrayCategories objectAtIndex:indexPath.row];
    //On met à jour les composants
    [self updateComponent];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
