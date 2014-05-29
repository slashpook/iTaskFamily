//
//  DDCustomButtonNotification.m
//  iTaskFamily
//
//  Created by Damien DELES on 12/03/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDCustomButtonNotification.h"

@implementation DDCustomButtonNotification

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        //Label des jours
        _labelDay = [[UILabel alloc] initWithFrame:CGRectMake(21, 0, 80, 50)];
        [self.labelDay setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.labelDay];
        
        //Vue de séparation
        _viewSeparator = [[UIView alloc] initWithFrame:CGRectMake(70, 10, 1, 30)];
        [self addSubview:self.viewSeparator];
        [self.viewSeparator setAlpha:0.0];
        
        //Label des notifications
        _labelNumberNotification = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 40, 50)];
        [self.labelNumberNotification setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.labelNumberNotification];
        [self.labelNumberNotification setAlpha:0.0];
        
    }
    return self;
}

//On met à jour le composant
- (void)updateComponent
{
    if ([self isSelected] == YES)
    {
        [[self labelDay] setFont:POLICE_EVENT_DAY_SELECTED];
        [[self labelNumberNotification] setFont:POLICE_EVENT_DAY_SELECTED];
        [self setColorNotification:[UIColor whiteColor]];
    }
    else
    {
        [[self labelDay] setFont:POLICE_EVENT_DAY];
        [[self labelNumberNotification] setFont:POLICE_EVENT_DAY];
        [self setColorNotification:[UIColor blackColor]];
    }
    
    //Si on a des notifications on les affiches
    if (![[[self labelNumberNotification] text] isEqualToString:@"0"])
    {
        //On met à jour les compsants
        [UIView animateWithDuration:0.3 animations:^{
            [[self labelDay] setFrame:CGRectMake(0, 0, 75, 50)];
            [self.viewSeparator setFrame:CGRectMake(70, 10, 1, 30)];
            [self.viewSeparator setAlpha:1.0];
            [self.labelNumberNotification setAlpha:1.0];
            [[self labelNumberNotification ] setFrame:CGRectMake(70, 0, 40, 50)];
        }];
    }
    else
    {
        //On met à jour les composants
        [UIView animateWithDuration:0.3 animations:^{
            [[self labelDay] setFrame:CGRectMake(21, 0, 80, 50)];
            [self.viewSeparator setFrame:CGRectMake(90, 10, 1, 30)];
            [self.viewSeparator setAlpha:0.0];
            [self.labelNumberNotification setAlpha:0.0];
            [[self labelNumberNotification ] setFrame:CGRectMake(100, 0, 40, 50)];
        }];
    }
    
    [self.labelDay setTextColor:self.colorNotification];
    [self.viewSeparator setBackgroundColor:self.colorNotification];
    [self.labelNumberNotification setTextColor:self.colorNotification];
}


@end
