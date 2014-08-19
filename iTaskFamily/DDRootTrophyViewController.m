//
//  DDRootTrophyViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 25/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDRootTrophyViewController.h"
#import "DDCategoryMiniatureCollectionViewCell.h"
#import "DDMainInformationTrophyViewController.h"
#import "DDListTrophyViewController.h"

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
    
    //On crée les controllers et on les ajoute à la scrollView
    _mainInformationTrophyViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"MainInformationTrophyViewController"];
    _listTrophyBronzeViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"ListTrophyViewController"];
    [[self.listTrophyBronzeViewController view] setFrame:CGRectMake(self.scrollViewGeneral.frame.size.width, 0, self.listTrophyBronzeViewController.view.frame.size.width, self.listTrophyBronzeViewController.view.frame.size.height)];
    _listTrophyArgentViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"ListTrophyViewController"];
    [[self.listTrophyArgentViewController view] setFrame:CGRectMake(self.scrollViewGeneral.frame.size.width * 2, 0, self.listTrophyArgentViewController.view.frame.size.width, self.listTrophyArgentViewController.view.frame.size.height)];
    _listTrophyOrViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"ListTrophyViewController"];
    [[self.listTrophyOrViewController view] setFrame:CGRectMake(self.scrollViewGeneral.frame.size.width * 3, 0, self.listTrophyOrViewController.view.frame.size.width, self.listTrophyOrViewController.view.frame.size.height)];
    
    [self.scrollViewGeneral setContentSize:CGSizeMake(self.scrollViewGeneral.frame.size.width * 4, self.scrollViewGeneral.frame.size.height)];
    [self.scrollViewGeneral setClipsToBounds:NO];
    [self.scrollViewGeneral setDelegate:self];
    [self.scrollViewGeneral addSubview:[self.mainInformationTrophyViewController view]];
    [self.scrollViewGeneral addSubview:[self.listTrophyBronzeViewController view]];
    [self.scrollViewGeneral addSubview:[self.listTrophyArgentViewController view]];
    [self.scrollViewGeneral addSubview:[self.listTrophyOrViewController view]];
    
    [self.pageControl setNumberOfPages:4];
    [self.pageControl setCurrentPage:0];
    
    //On met à jour les composants
    [self updateComponent];
}


#pragma mark - Fonctions du controller

//On met à jour la vue
- (void)updateComponent
{
    NSArray *arrayTrophies = [[DDDatabaseAccess instance] getCategoryTrophiesForCategorySorted:category];
    
    //On met à jour toutes les sous vue de la scrollView
    [self.mainInformationTrophyViewController setCategory:category];
    [self.mainInformationTrophyViewController updateComponent];
    [self.listTrophyBronzeViewController setCategory:category];
    [self.listTrophyBronzeViewController setTrophy:[arrayTrophies objectAtIndex:0]];
    [self.listTrophyBronzeViewController updateComponent];
    [self.listTrophyArgentViewController setCategory:category];
    [self.listTrophyArgentViewController setTrophy:[arrayTrophies objectAtIndex:1]];
    [self.listTrophyArgentViewController updateComponent];
    [self.listTrophyOrViewController setCategory:category];
    [self.listTrophyOrViewController setTrophy:[arrayTrophies objectAtIndex:2]];
    [self.listTrophyOrViewController updateComponent];
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


#pragma mark - UIScrollViewDelegate functions

//Fonction utilisé pour mettre à jour les données du joueur
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //On récupère la page courante
    int currentPage = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
    self.pageControl.currentPage = currentPage;
}

//On change la page
- (IBAction)changePlayerInPageControl:(id)sender
{
    [self.scrollViewGeneral setContentOffset:CGPointMake((self.scrollViewGeneral.contentSize.width / 4) * self.pageControl.currentPage, 0) animated:YES];
}

@end
