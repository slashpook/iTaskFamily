//
//  Task.h
//  iTaskFamily
//
//  Created by Damien DELES on 09/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Categories, Event, Player, Realisation;

@interface Task : NSManagedObject

@property (nonatomic, retain) NSNumber * historique;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * point;
@property (nonatomic, retain) Categories *categories;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) Player *player;
@property (nonatomic, retain) NSSet *realisation;
@end

@interface Task (CoreDataGeneratedAccessors)

- (void)addRealisationObject:(Realisation *)value;
- (void)removeRealisationObject:(Realisation *)value;
- (void)addRealisation:(NSSet *)values;
- (void)removeRealisation:(NSSet *)values;

//On set une nouvelle tache
- (void)setTaskWithTask:(Task *)task;

@end
