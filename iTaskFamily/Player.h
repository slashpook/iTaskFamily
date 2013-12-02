//
//  Player.h
//  iTaskFamily
//
//  Created by Damien DELES on 02/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Player : NSManagedObject

@property (nonatomic, retain) NSString * pathImage;
@property (nonatomic, retain) NSString * pseudo;
@property (nonatomic, retain) NSNumber * scoreSemaine;
@property (nonatomic, retain) NSNumber * scoreSemainePrecedente;
@property (nonatomic, retain) NSNumber * scoreTotal;
@property (nonatomic, retain) NSNumber * tropheesRealised;

@end
