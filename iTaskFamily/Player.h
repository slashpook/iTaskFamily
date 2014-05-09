//
//  Player.h
//  iTaskFamily
//
//  Created by Damien DELES on 08/05/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Achievement;

@interface Player : NSManagedObject

@property (nonatomic, retain) NSString * pathImage;
@property (nonatomic, retain) NSString * pseudo;
@property (nonatomic, retain) NSSet *achievments;
@end

@interface Player (CoreDataGeneratedAccessors)

- (void)addAchievmentsObject:(Achievement *)value;
- (void)removeAchievmentsObject:(Achievement *)value;
- (void)addAchievments:(NSSet *)values;
- (void)removeAchievments:(NSSet *)values;

@end
