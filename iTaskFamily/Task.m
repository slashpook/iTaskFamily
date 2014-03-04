//
//  Task.m
//  iTaskFamily
//
//  Created by Damien DELES on 09/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "Task.h"
#import "Categories.h"
#import "Event.h"
#import "Player.h"
#import "Realisation.h"


@implementation Task

@dynamic historique;
@dynamic name;
@dynamic point;
@dynamic categories;
@dynamic event;
@dynamic player;
@dynamic realisation;

//On set une nouvelle tache
- (void)setTaskWithTask:(Task *)task
{
    [self setHistorique:task.historique];
    [self setName:task.name];
    [self setPoint:task.point];
    [self setCategories:task.categories];
    [self setEvent:task.event];
    [self setPlayer:task.player];
    [self setRealisation:task.realisation];
}

@end
