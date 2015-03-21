//
//  DDAppDelegate.m
//  iTaskFamily
//
//  Created by Damien DELES on 20/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDAppDelegate.h"
#import "DDParserXML.h"
@import SystemConfiguration.CaptiveNetwork;

@implementation DDAppDelegate 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
//    NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);
//    
//    NSDictionary *SSIDInfo;
//    for (NSString *interfaceName in interfaceNames) {
//        SSIDInfo = CFBridgingRelease(
//                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
//        NSLog(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);
//        
//        BOOL isNotEmpty = (SSIDInfo.count > 0);
//        if (isNotEmpty) {
//            break;
//        }
//    }
    
    //On initialise la couleur par default de l'appli
    if ([DDHelperController getMainTheme] == nil)
        [DDHelperController saveThemeWithColor:COULEUR_BLEU];
    
    //On set le booléen pour indiquer que l'on vient de lancer l'application pour la première fois
    [self setIsFirstLaunch:YES];
    
    //On cache la barre de status
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    //On set le premier joueur
    [[DDManagerSingleton instance] setCurrentPlayer:[[DDDatabaseAccess instance] getFirstPlayer]];
    
    //Alloc the window and set the mainStoryboard
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor clearColor];
    
    //Set the tabBar controller
	_rootViewController = [[[DDManagerSingleton instance] storyboard] instantiateInitialViewController];
    [self.window setRootViewController:self.rootViewController];
    
    [self.window makeKeyAndVisible];
    
    //On initialise le parser
    _parser = [[DDParserXML alloc] init];
    //On parse les données
    [self parseData];
    
    //Si on est sur le premier lancement, on affiche le tutoriel de base
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstLaunch"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:true] forKey:@"isFirstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSelector:@selector(displayTutorial) withObject:nil afterDelay:1.0];
    }
    
    return YES;
}

- (void)displayTutorial {
    _tutorialViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"TutorialViewController"];
    [self.tutorialViewController setDelegate:self];
    _popOverViewController = [[[DDManagerSingleton instance] storyboard] instantiateViewControllerWithIdentifier:@"PopOverViewController"];
    
    [self.window.rootViewController.view addSubview:self.popOverViewController.view];
    [self.tutorialViewController setTutorialChapter:0];
    
    //On présente la popUp
    CGRect frame = [[UIScreen mainScreen] bounds];
    [self.popOverViewController presentPopOverWithContentView:self.tutorialViewController.view andSize:frame.size andOffset:CGPointMake(0, 0)];
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
    {
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(updateDateAndMeteo) userInfo:nil repeats:NO];
         
    }
    
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
    if ([[[DDDatabaseAccess instance] getCategoryTasks] count] == 0)
    {
        //On parse
        [self.parser parseXMLFile];
    }
}


#pragma mark - DDTutorialViewControllerProtocol fonctions

//Fonction pour fermer la popUp
- (void)closeTutorialView
{
    //On enlève la popUp
    [self.popOverViewController hide];
}

@end
    
