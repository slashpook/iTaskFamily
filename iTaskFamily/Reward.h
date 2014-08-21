//
//  Reward.h
//  iTaskFamily
//
//  Created by Damien DELES on 19/08/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Reward : NSManagedObject

@property (nonatomic, retain) NSString * libelle;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * weekAndYear;

@end
