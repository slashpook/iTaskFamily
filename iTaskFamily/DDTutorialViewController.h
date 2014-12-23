//
//  DDTutorialViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 23/12/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDTutorialViewControllerProtocol <NSObject>

- (void)closeTutorialView;

@end

@interface DDTutorialViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


#pragma mark - Variables

//Delegate de la vue
@property (weak, nonatomic) id<DDTutorialViewControllerProtocol> delegate;

//Label du titre de la tableView
@property (weak, nonatomic) IBOutlet UILabel *labelTitreTableView;

//TableView des chapitres du tutoriel
@property (weak, nonatomic) IBOutlet UITableView *tableViewChapitre;

//View contenant tous les éléments du tutorial
@property (weak, nonatomic) IBOutlet UIView *viewTutorial;

//Titre du chapitre
@property (weak, nonatomic) IBOutlet UILabel *labelTitre;

//ScrollView du tutoriel
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewTutorial;

//PageControl du tutorial
@property (weak, nonatomic) IBOutlet UIPageControl *pageControlTutorial;

//Label de description de l'image du tutoriel en cours
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;

//Tableau de données de la tableView
@property (strong, nonatomic) NSArray *arrayTutorial;


#pragma mark - Fonctions


@end
