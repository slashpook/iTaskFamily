//
//  CategoryTrophy.h
//  iTaskFamily
//
//  Created by Damien DELES on 08/05/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CategoryTask;

@interface CategoryTrophy : NSManagedObject

@property (nonatomic, retain) NSString * libelle;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) CategoryTask *category;

@end
