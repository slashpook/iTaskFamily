//
//  Task.h
//  iTaskFamily
//
//  Created by Damien DELES on 08/05/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Achievement, CategoryTask, Trophy;

@interface Task : NSManagedObject

@property (nonatomic, retain) NSNumber * history;
@property (nonatomic, retain) NSString * libelle;
@property (nonatomic, retain) NSNumber * point;
@property (nonatomic, retain) NSSet *achievments;
@property (nonatomic, retain) CategoryTask *category;
@property (nonatomic, retain) NSSet *trophies;
@end

@interface Task (CoreDataGeneratedAccessors)

- (void)addAchievmentsObject:(Achievement *)value;
- (void)removeAchievmentsObject:(Achievement *)value;
- (void)addAchievments:(NSSet *)values;
- (void)removeAchievments:(NSSet *)values;

- (void)addTrophiesObject:(Trophy *)value;
- (void)removeTrophiesObject:(Trophy *)value;
- (void)addTrophies:(NSSet *)values;
- (void)removeTrophies:(NSSet *)values;

@end
