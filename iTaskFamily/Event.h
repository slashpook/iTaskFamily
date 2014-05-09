//
//  Event.h
//  iTaskFamily
//
//  Created by Damien DELES on 08/05/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Achievement;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSNumber * checked;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) NSNumber * recurrent;
@property (nonatomic, retain) Achievement *achievement;

@end
