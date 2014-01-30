//
//  Player.h
//  iTaskFamily
//
//  Created by Damien DELES on 09/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Task, Trophy;

@interface Player : NSManagedObject

@property (nonatomic, retain) NSString * pathImage;
@property (nonatomic, retain) NSString * pseudo;
@property (nonatomic, retain) NSNumber * scoreSemaine;
@property (nonatomic, retain) NSNumber * scoreSemainePrecedente;
@property (nonatomic, retain) NSNumber * scoreTotal;
@property (nonatomic, retain) NSNumber * tropheesRealised;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *task;
@property (nonatomic, retain) NSSet *trophy;
@end

@interface Player (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

- (void)addTaskObject:(Task *)value;
- (void)removeTaskObject:(Task *)value;
- (void)addTask:(NSSet *)values;
- (void)removeTask:(NSSet *)values;

- (void)addTrophyObject:(Trophy *)value;
- (void)removeTrophyObject:(Trophy *)value;
- (void)addTrophy:(NSSet *)values;
- (void)removeTrophy:(NSSet *)values;

@end
