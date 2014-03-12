//
//  DDEventManagerTableViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 12/03/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDEventManagerTableViewController.h"

@interface DDEventManagerTableViewController ()

@end

@implementation DDEventManagerTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableViewElement reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch (indexPath.row)
    {
        case 0:
            cell = self.cell1;
            break;
        case 1:
        {
            cell = self.cell2;
            break;
        }
        case 2:
            cell = self.cell3;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[self delegate] cellSelectedAtIndexPath:indexPath];
}

@end
