//
//  RecurrenceEnd.h
//  iTaskFamily
//
//  Created by Damien DELES on 15/07/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface RecurrenceEnd : NSManagedObject

@property (nonatomic, retain) NSString * weekAndYear;
@property (nonatomic, retain) Event *events;

@end
