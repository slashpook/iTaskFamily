//
//  DDTaskManagerTableViewController.h
//  iTaskFamily
//
//  Created by Damien DELES on 12/03/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDTaskManagerTableViewProtocol <NSObject>

- (void)cellSelectedAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface DDTaskManagerTableViewController : UITableViewController


#pragma mark - Variables

//Delegate du controller
@property (weak, nonatomic) id<DDTaskManagerTableViewProtocol> delegate;

//TableView des infos de la tache
@property (weak, nonatomic) IBOutlet UITableView *tableViewTaskInfo;

//First cell
@property (strong, nonatomic) IBOutlet UITableViewCell *cell1;

//Label du titre du nom de la tache
@property (weak, nonatomic) IBOutlet UILabel *labelTitleNameTask;

//TextField du nom de la tache
@property (weak, nonatomic) IBOutlet UITextField *textFieldNameTask;

//Second cell
@property (strong, nonatomic) IBOutlet UITableViewCell *cell2;

//Label du titre du nom de la catégorie
@property (weak, nonatomic) IBOutlet UILabel *labelTitleNameCategory;

//Label du nom de la catégorie
@property (weak, nonatomic) IBOutlet UILabel *labelNameCategory;

//Last cell
@property (strong, nonatomic) IBOutlet UITableViewCell *cell3;

//Label du titre du nombre de point
@property (weak, nonatomic) IBOutlet UILabel *labelTitlePoint;

//Label du nombre de point
@property (weak, nonatomic) IBOutlet UITextField *textFieldPoint;

@end
