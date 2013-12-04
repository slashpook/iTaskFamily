//
//  DDPlayerListViewController.m
//  ITaskFamily
//
//  Created by DAMIEN on 20/11/12.
//  Copyright (c) 2012 INGESUP. All rights reserved.
//

#import "DDPlayerListViewController.h"
#import "DDCustomPlayerListCollectionViewCell.h"
#import "Player.h"

@interface DDPlayerListViewController ()

@end

@implementation DDPlayerListViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //On configure le titre
    [self.lblTitre setBackgroundColor:[UIColor clearColor]];
    [self.lblTitre setFont:POLICE_CROPPER_TITLE];
    [self.lblTitre setTextColor:COULEUR_WHITE];
    [self.lblTitre setText:@"Choisissez un joueur"];
    
    //On configure le gestureRecognizer
    [self.gestureRecognizer setDelegate:self];
    
    //Implémentation du collection View
    _collectionViewLayout = [[UICollectionViewLayout alloc] init];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(250, 285)];
    [flowLayout setMinimumInteritemSpacing:20.0];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

    //On set la collectionView
    _collectionViewPlayer = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 768, 500) collectionViewLayout:flowLayout];
    [self.collectionViewPlayer setBackgroundColor:[UIColor clearColor]];
    [self.collectionViewPlayer setDelegate:self];
    [self.collectionViewPlayer setDataSource:self];
    [[self view] insertSubview:_collectionViewPlayer belowSubview:_gestureRecognizer.view];
    [self.collectionViewPlayer registerClass:[DDCustomPlayerListCollectionViewCell class] forCellWithReuseIdentifier:@"DefaultCell"];
    [self.collectionViewPlayer reloadData];
    [self.collectionViewPlayer setIndicatorStyle:UIScrollViewIndicatorStyleDefault];
    
    //On set le tableau
    _arrayPlayer = [[NSMutableArray alloc] initWithArray:[[DDDatabaseAccess instance] getPlayers]];
}

- (void)viewWillAppear:(BOOL)animated
{
    //On calcule la taille de la tableView
    float numberOfSection = [self.arrayPlayer count] / 3.0;
       
    if (numberOfSection <= 1.0)
    {
        int widthCollectionView;
        if ([self.arrayPlayer count] == 1)
            widthCollectionView = 250;
        else if ([self.arrayPlayer count] == 2)
            widthCollectionView = 520;
        else
            widthCollectionView = 790;
        
        [self.collectionViewPlayer setFrame:CGRectMake((1024 - widthCollectionView)/2, 231.5, widthCollectionView, 285)];
    }
    else
        [self.collectionViewPlayer setFrame:CGRectMake(117, 139, 800, 590)];
    
    [self.collectionViewPlayer reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCollectionViewPlayer:nil];
    [self setLblTitre:nil];
    [self setGestureRecognizer:nil];
    [super viewDidUnload];
}


#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [self.arrayPlayer count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDCustomPlayerListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DefaultCell" forIndexPath:indexPath];
    
    //On récupère le joueur à l'index donnée
    Player *player = [self.arrayPlayer objectAtIndex:indexPath.row];
    
    if (![cell.buttonPlayer respondsToSelector:@selector(onPushPlayer:)])
    {
        [[cell buttonPlayer] addTarget:self action:@selector(onPushPlayer:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //On set l'index au tag
    [cell.buttonPlayer setTag:indexPath.row];
    
    [[cell buttonPlayer] setImage:[[[DDManagerSingleton instance] dictImagePlayer] objectForKey:player.pseudo] forState:UIControlStateNormal];
    
    [[cell labelPseudo] setText:player.pseudo];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate


//On appuie sur un joueur
- (IBAction)onPushPlayer:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [self.delegate closePopOverPlayerListWithIndex:button.tag];
}


#pragma mark Fonction de UIGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == self.view || touch.view == self.collectionViewPlayer)
        [self.delegate closePopOverPlayerListWithIndex:-1];
    
    return NO;
}

@end