//
//  DDPlayerListViewController.h
//  ITaskFamily
//
//  Created by DAMIEN on 20/11/12.
//  Copyright (c) 2012 INGESUP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDPlayerListViewProtocol <NSObject>

-(void)closePopOverPlayerListWithIndex:(int)index;

@end

@interface DDPlayerListViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UIGestureRecognizerDelegate>


#pragma mark - Variables

//CollectionView de la vue
@property (strong, nonatomic) UICollectionView *collectionViewPlayer;

//CollectionView layer
@property (strong, nonatomic) UICollectionViewLayout *collectionViewLayout;

//Label du titre
@property (strong, nonatomic) IBOutlet UILabel *lblTitre;

//Gesture de la vue
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *gestureRecognizer;

//Array des joueurs
@property (strong, nonatomic) NSMutableArray *arrayPlayer;

//Delegate de la vue
@property (weak, nonatomic) id<DDPlayerListViewProtocol> delegate;


#pragma mark - Fonctions

@end
