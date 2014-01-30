//
//  Realisation.h
//  iTaskFamily
//
//  Created by Damien DELES on 09/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface Realisation : NSManagedObject

@property (nonatomic, retain) NSNumber * realized;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Task *task;

@end
