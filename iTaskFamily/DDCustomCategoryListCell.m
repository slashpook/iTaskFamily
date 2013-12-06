//
//  DDCustomCategoryListCell.m
//  iTaskFamily
//
//  Created by Damien DELES on 06/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDCustomCategoryListCell.h"

@implementation DDCustomCategoryListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected == YES)
        [self.contentView setBackgroundColor:COULEUR_CELL_SELECTED];
    else
        [self.contentView setBackgroundColor:COULEUR_WHITE];
    
    [self.contentView setNeedsDisplay];
}

@end
