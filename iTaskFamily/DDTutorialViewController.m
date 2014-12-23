//
//  DDTutorialViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 23/12/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDTutorialViewController.h"
#import "DDSettingTableViewCell.h"

@interface DDTutorialViewController ()

@end

@implementation DDTutorialViewController

#pragma mark - Fonctions de bases

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _arrayTutorial = [NSArray arrayWithObjects:NSLocalizedString(@"TUTO1", nil), NSLocalizedString(@"TUTO2", nil), NSLocalizedString(@"TUTO3", nil), NSLocalizedString(@"TUTO4", nil), NSLocalizedString(@"TUTO5", nil), NSLocalizedString(@"TUTO6", nil), NSLocalizedString(@"TUTO7", nil), NSLocalizedString(@"TUTO8", nil), NSLocalizedString(@"TUTO9", nil), NSLocalizedString(@"TUTO10", nil), NSLocalizedString(@"TUTO11", nil), nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //On set la couleur du thème principal
    [self.labelTitreTableView setTextColor:[DDHelperController getMainTheme]];
}


#pragma mark - Fonctions du controller

//On ferme la vue de tutorial
- (IBAction)onPushButtonClose:(id)sender {
    [self.delegate closeTutorialView];
}

//On affiche ou non la tableView des chapitres
- (IBAction)onPushButtonList:(id)sender {
    if (self.viewTutorial.frame.origin.x == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.viewTutorial setFrame:CGRectMake(300, 0, self.viewTutorial.frame.size.width, self.viewTutorial.frame.size.height)];
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            [self.viewTutorial setFrame:CGRectMake(0, 0, self.viewTutorial.frame.size.width, self.viewTutorial.frame.size.height)];
        }];
    }
}


#pragma mark - TableView Delegate fonctions

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayTutorial count];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableViewChapitre cellForRowAtIndexPath:indexPath];
    [cell setBackgroundColor:COULEUR_CELL_SELECTED];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableViewChapitre cellForRowAtIndexPath:indexPath];
    [cell setBackgroundColor:COULEUR_WHITE];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //On récupère la cellule
    DDSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellTutorial" forIndexPath:indexPath];
    
    [cell.labelTutorial setText:[self.arrayTutorial objectAtIndex:indexPath.row]];
    [cell.labelTutorial setBackgroundColor:COULEUR_TRANSPARENT];
    
    return cell;
}

@end
