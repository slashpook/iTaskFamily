//
//  DDRootViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 20/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDRootViewController.h"
#import "DDMenuView.h"
#import "DDHomeViewController.h"

@interface DDRootViewController ()

@end

@implementation DDRootViewController


#pragma mark - Fonctions de base

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Initialise les view de l'appli
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _homeViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
