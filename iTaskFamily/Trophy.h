//
//  Trophy.h
//  iTaskFamily
//
//  Created by Damien DELES on 03/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Categories, Player;

@interface Trophy : NSManagedObject

@property (nonatomic, retain) NSNumber * isRealized;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Categories *categories;
@property (nonatomic, retain) Player *player;

@end
