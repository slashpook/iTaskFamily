//
//  DDAppDelegate.m
//  iTaskFamily
//
//  Created by Damien DELES on 20/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDAppDelegate.h"

@implementation DDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //On set le booléen pour indiquer que l'on vient de lancer l'application pour la première fois
    [self setIsFirstLaunch:YES];
    
    //On cache la barre de status
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //Si ce n'est pas le premier lancement, on met à jour la météo et la date
    if (!self.isFirstLaunch)
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(updateDateAndMeteo) userInfo:nil repeats:NO];
    
    [self setIsFirstLaunch:NO];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)updateDateAndMeteo
{
    //On lance les notification pour mettre à jour la date et la météo
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_DATE object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_METEO object:nil];
}

@end
    
