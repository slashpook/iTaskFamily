//
//  Categories.h
//  iTaskFamily
//
//  Created by Damien DELES on 09/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task, Trophy;

@interface Categories : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *task;
@property (nonatomic, retain) NSSet *trophy;
@end

@interface Categories (CoreDataGeneratedAccessors)

- (void)addTaskObject:(Task *)value;
- (void)removeTaskObject:(Task *)value;
- (void)addTask:(NSSet *)values;
- (void)removeTask:(NSSet *)values;

- (void)addTrophyObject:(Trophy *)value;
- (void)removeTrophyObject:(Trophy *)value;
- (void)addTrophy:(NSSet *)values;
- (void)removeTrophy:(NSSet *)values;

@end
