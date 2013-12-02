//
//  DDManagerSingleton.m
//  iTaskFamily
//
//  Created by Damien DELES on 29/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDManagerSingleton.h"
#import "Player.h"

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
        
        NSMutableArray *arrayPlayer = [[DDDatabaseAccess instance] getPlayers];
        
        //Dans un thread à part on rentre les images dans un dictionaire
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            int compteur = 0;
            for (Player *player in arrayPlayer)
            {
                //On rajoute l'image
                [self.dictImagePlayer setObject:[UIImage imageWithContentsOfFile:player.pathImage] forKey:player.pseudo];
                
                //Si on doit faire un update graphique
                dispatch_sync(dispatch_get_main_queue(), ^{
                   
                });
                compteur ++;
            }
        });

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
    
    [self.library enumerateGroupsWithTypes:ALAssetsGroupAll
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
@end
