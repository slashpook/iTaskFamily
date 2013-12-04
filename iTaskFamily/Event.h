//
//  Event.h
//  iTaskFamily
//
//  Created by Damien DELES on 03/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Player, Task;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) NSNumber * isFinished;
@property (nonatomic, retain) NSNumber * recurrence;
@property (nonatomic, retain) Task *task;
@property (nonatomic, retain) Player *player;

@end
