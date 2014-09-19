//
//  DDSettingTableViewCell.m
//  iTaskFamily
//
//  Created by Damien DELES on 19/09/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDSettingTableViewCell.h"

@implementation DDSettingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
