//
//  RecurrenceEnd.h
//  iTaskFamily
//
//  Created by Damien DELES on 29/05/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface RecurrenceEnd : NSManagedObject

@property (nonatomic, retain) NSString * weekAndYear;
@property (nonatomic, retain) NSSet *events;
@end

@interface RecurrenceEnd (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
