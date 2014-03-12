//
//  DDEventManagerTableViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 12/03/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDEventManagerTableViewProtocol <NSObject>

- (void)cellSelectedAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface DDEventManagerTableViewController : UITableViewController


#pragma mark - Variables

//Delegate du controller
@property (weak, nonatomic) id<DDEventManagerTableViewProtocol> delegate;

//TableView de l'évènement
@property (weak, nonatomic) IBOutlet UITableView *tableViewElement;

//Cellule Tache
@property (strong, nonatomic) IBOutlet UITableViewCell *cell1;

//Label titre de la cellule tache
@property (weak, nonatomic) IBOutlet UILabel *labelTacheTitre;

//Label content de la cellule tache
@property (weak, nonatomic) IBOutlet UILabel *labelTacheContent;

//Cellule Date
@property (strong, nonatomic) IBOutlet UITableViewCell *cell2;

//Label titre de la cellule date
@property (weak, nonatomic) IBOutlet UILabel *labelDateTitre;

//Label content de la cellule date
@property (weak, nonatomic) IBOutlet UILabel *labelDateContent;

//Cellule Récurrence
@property (strong, nonatomic) IBOutlet UITableViewCell *cell3;

//Label titre de la cellule récurrence
@property (weak, nonatomic) IBOutlet UILabel *labelRecurrence;

//Switch de la cellule récurrence
@property (weak, nonatomic) IBOutlet UISwitch *switchRecurrence;


#pragma mark - Fonctions


@end
