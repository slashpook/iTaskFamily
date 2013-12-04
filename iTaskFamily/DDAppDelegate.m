//
//  DDAppDelegate.m
//  iTaskFamily
//
//  Created by Damien DELES on 20/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDAppDelegate.h"
#import "DDParserXML.h"

@implementation DDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //On set le booléen pour indiquer que l'on vient de lancer l'application pour la première fois
    [self setIsFirstLaunch:YES];
    
    //On cache la barre de status
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    //On set le premier joueur
    [[DDManagerSingleton instance] setCurrentPlayer:[[DDDatabaseAccess instance] getFirstPlayer]];
    
    //Alloc the window and set the mainStoryboard
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor clearColor];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //Set the tabBar controller
	_rootViewController = [mainStoryboard instantiateInitialViewController];
    [self.window setRootViewController:self.rootViewController];
    [self.window makeKeyAndVisible];
    
    //On initialise le parser
    _parser = [[DDParserXML alloc] init];
    //On parse les données
    [self parseData];
    
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
    //On charge les images du imagePicker pour les joueurs
    [[DDManagerSingleton instance] loadImagePicker];
    
    //Si ce n'est pas le premier lancement, on met à jour la météo et la date
    if (!self.isFirstLaunch)
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(updateDateAndMeteo) userInfo:nil repeats:NO];
    
    [self setIsFirstLaunch:NO];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//On met à jour la date et la météo
- (void)updateDateAndMeteo
{
    //On lance les notification pour mettre à jour la date et la météo
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_DATE object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_METEO object:nil];
}


//On parse les données du fichier XML si on a aucune tache
- (void)parseData
{
    //Si on a aucune catégories donc aucune données, on parse le document xml
    if ([[DDDatabaseAccess instance] getCategories] == nil)
    {
        //On parse
        [self.parser parseXMLFile];
    }
}

@end
    
