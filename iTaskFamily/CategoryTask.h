//
//  CategoryTask.h
//  iTaskFamily
//
//  Created by Damien DELES on 08/05/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CategoryTrophy, Task;

@interface CategoryTask : NSManagedObject

@property (nonatomic, retain) NSString * libelle;
@property (nonatomic, retain) NSSet *categoryTrophies;
@property (nonatomic, retain) NSSet *tasks;
@end

@interface CategoryTask (CoreDataGeneratedAccessors)

- (void)addCategoryTrophiesObject:(CategoryTrophy *)value;
- (void)removeCategoryTrophiesObject:(CategoryTrophy *)value;
- (void)addCategoryTrophies:(NSSet *)values;
- (void)removeCategoryTrophies:(NSSet *)values;

- (void)addTasksObject:(Task *)value;
- (void)removeTasksObject:(Task *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;

@end
