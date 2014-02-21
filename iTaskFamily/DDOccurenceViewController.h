//
//  DDOccurenceViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 20/02/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCustomNavigationBarController.h"

@protocol DDOccurenceViewProtocol <NSObject>

-(void)saveOccurencewithArray:(NSMutableArray *)arrayOccurence;

@end

@interface DDOccurenceViewController : UIViewController <DDCustomNavBarProtocol>


#pragma mark - Variables

//TableView des occurences
@property (weak, nonatomic) IBOutlet UITableView *tableViewOccurence;

//Delegate de la vue
@property (strong, nonatomic) id<DDOccurenceViewProtocol> delegate;

//Bool pour savoir si on modifie ou non
@property (assign, nonatomic) BOOL isModifyEvent;

//Tableau des occurences
@property (strong, nonatomic) NSMutableArray *arrayOccurence;

//Tableau des indexPaths sélectionnés
@property (strong, nonatomic) NSMutableArray *arrayIndexPath;

//Tableau des occurences sauvées
@property (strong, nonatomic) NSMutableArray *arrayOccurenceSaved;

//Navigation bar
@property (strong, nonatomic) DDCustomNavigationBarController *custoNavBar;


#pragma mark - Fonctions

@end
