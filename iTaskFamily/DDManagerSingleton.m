//
//  DDManagerSingleton.m
//  iTaskFamily
//
//  Created by Damien DELES on 29/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDManagerSingleton.h"

@implementation DDManagerSingleton


#pragma mark - Singleton fonctions

//Instance du singleton
+ (DDManagerSingleton *)instance
{
	static DDManagerSingleton *instance;
	
	@synchronized(self) {
		if(!instance) {
			instance = [[DDManagerSingleton alloc] init];
		}
	}
	
	return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _arrayImagePicker = [[NSMutableArray alloc] init];
        _library = [[ALAssetsLibrary alloc] init];
        _dictImagePlayer = [[NSMutableDictionary alloc] init];
        
        //On récupère la liste des joueurs
        NSMutableArray *arrayPlayer = [NSMutableArray arrayWithArray:[[DDDatabaseAccess instance] getPlayers]];
        
        int compteur = 0;
        for (Player *player in arrayPlayer)
        {
            //On rajoute l'image
            [self.dictImagePlayer setObject:[UIImage imageWithContentsOfFile:player.pathImage] forKey:player.pseudo];
            compteur ++;
        }
        
        //On crée le dictionnaire des couleurs des catégories
        _dictColor = [[NSDictionary alloc] initWithObjectsAndKeys:COULEUR_CUISINE, @"Cuisine", COULEUR_CHAMBRE, @"Chambre", COULEUR_DOUCHE, @"Douche", COULEUR_EXTERIEUR, @"Extérieur", COULEUR_AUTRE, @"Autre", COULEUR_SALON, @"Salon", COULEUR_GARAGE, @"Garage", COULEUR_PLUS_UTILISE, NSLocalizedString(@"PLUS_UTILISE", nil), nil];
        

        //On crée le tableau des jours de la semaine
        _arrayWeek = [[NSArray alloc] initWithObjects:NSLocalizedString(@"DIMANCHE", nil), NSLocalizedString(@"LUNDI", nil), NSLocalizedString(@"MARDI", nil), NSLocalizedString(@"MERCREDI", nil), NSLocalizedString(@"JEUDI", nil), NSLocalizedString(@"VENDREDI", nil), NSLocalizedString(@"SAMEDI", nil), nil];
        
        //On crée le tableau des jours de la semaine
        _arrayMonth = [[NSArray alloc] initWithObjects:NSLocalizedString(@"JANVIER", nil), NSLocalizedString(@"FEVRIER", nil), NSLocalizedString(@"MARS", nil), NSLocalizedString(@"AVRIL", nil), NSLocalizedString(@"MAI", nil), NSLocalizedString(@"JUIN", nil), NSLocalizedString(@"JUILLET", nil), NSLocalizedString(@"AOUT", nil), NSLocalizedString(@"SEPTEMBRE", nil), NSLocalizedString(@"OCTOBRE", nil), NSLocalizedString(@"NOVEMBRE", nil), NSLocalizedString(@"DECEMBRE", nil), nil];
        
        //On instancie le storyboard
        _storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }
    return self;
}

//On charge les images de la bibliothèque
-(void)loadImagePicker
{
    NSMutableArray *arrayURLImage = [[NSMutableArray alloc] init];
    
    //On supprime les données du tableau
    [self.arrayImagePicker removeAllObjects];
    
    void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop)  {
        if(result != NULL) {
            if ([arrayURLImage containsObject:result.defaultRepresentation.url] == false)
            {
                [arrayURLImage addObject:result.defaultRepresentation.url];
                [self.arrayImagePicker addObject:result];
            }
        }
    };
    
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) =  ^(ALAssetsGroup *group, BOOL *stop)  {
        if(group != nil) {
            // NSLog(@"Groupe %@", group);
            [group enumerateAssetsUsingBlock:assetEnumerator];
        }
        
    };
    
    [self.library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                usingBlock:assetGroupEnumerator
                              failureBlock: ^(NSError *error) {
                                  NSLog(@"Failure");
                              }];
}

//On enregistre l'image de profil du joueur et on set son chemin
- (void)saveImgProfilForPlayer:(Player *)player withImage:(UIImage *)imgProfil
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //On crée le chemin de l'image
        NSArray *defaultPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *imgProfilPath = [defaultPaths objectAtIndex:0];
        imgProfilPath = [imgProfilPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", player.pseudo]];
        
        //On enregistre l'image
        NSError *error = [[NSError alloc] init];
        [UIImageJPEGRepresentation(imgProfil, 1.0) writeToFile:imgProfilPath options:NSDataWritingAtomic error:&error];
        [self avoidBackupOniCloudForPath:imgProfilPath];
    });
    
    //On update l'image l'image du joueur
    [[self dictImagePlayer] setObject:imgProfil forKey:player.pseudo];
}

//On met à jour l'image de profil du joueur
- (void)updateImgProfilForPlayer:(Player *)player WithPath:(NSString *)path withImage:(UIImage *)imgProfil
{
    //On supprime l'ancienne image
    [self deleteImgProfilForPath:path];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //On crée le chemin de l'image
        NSArray *defaultPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *imgProfilPath = [defaultPaths objectAtIndex:0];
        imgProfilPath = [imgProfilPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", player.pseudo]];
        
        //On enregistre l'image
        NSError *error = [[NSError alloc] init];
        [UIImageJPEGRepresentation(imgProfil, 1.0) writeToFile:imgProfilPath options:NSDataWritingAtomic error:&error];
        
        [self avoidBackupOniCloudForPath:imgProfilPath];
    });
    
    //On update l'image l'image du joueur
    [[self dictImagePlayer] setObject:imgProfil forKey:player.pseudo];
}

//On supprime l'image de profil du joueur que l'on va supprimer
- (void)deleteImgProfilForPath:(NSString *)path
{
    //On supprime l'image si elle existe
    if ([UIImage imageWithContentsOfFile:path] != nil)
    {
        NSError *error = [[NSError alloc] init];
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    }
}


//On évite la backup sur iCloud
-(void)avoidBackupOniCloudForPath:(NSString *)path
{
    NSError *error = nil;
    NSURL* url = [NSURL fileURLWithPath:path];
    
    [url setResourceValue: [NSNumber numberWithBool:YES]
                   forKey: NSURLIsExcludedFromBackupKey
                    error: &error];
}

//Indique si on se géolocalise ou non
- (BOOL)isGeolocalisationActivate
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"geolocalisation"];
}

//Set la géolocalisation
- (void)setIsGeolocationActivate:(BOOL)isGeolocalisationActivate
{
    [[NSUserDefaults standardUserDefaults] setBool:isGeolocalisationActivate forKey:@"geolocalisation"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//On récupère la météo
- (NSString *)getMeteo
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"meteo"] == nil)
        return @"Toulouse";
    else
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"meteo"];
}

//Set la météo
- (void)setMeteo:(NSString *)meteo
{
    [[NSUserDefaults standardUserDefaults] setObject:meteo forKey:@"meteo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
