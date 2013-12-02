//
//  DDRootTrophyViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 25/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDRootTrophyViewController.h"
#import "DDTrophyRootCell.h"

@interface DDRootTrophyViewController ()

@end

@implementation DDRootTrophyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //On configure le background de la vue
    [[self view] setBackgroundColor:COULEUR_WHITE];
    
    //On s'enregistre sur la classe de la cellule
    [self.tableViewTrophy registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //On récupère la cellule
    DDTrophyRootCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrophyRootCell" forIndexPath:indexPath];
    
    return cell;
}

@end
