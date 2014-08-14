//
//  DDRootTrophyViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 25/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDMainInformationTrophyViewController;

@interface DDRootTrophyViewController : UIViewController


#pragma mark - Variable

//La collectionView qui contient les catégories
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewMiniature;

//ScrollView generale
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewGeneral;

//Page control du controller
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

//Le controller avec les infos principales
@property (strong, nonatomic) DDMainInformationTrophyViewController *mainInformationTrophyViewController;


#pragma mark - Fonctions

//On met à jour la vue
- (void)updateComponent;

@end
