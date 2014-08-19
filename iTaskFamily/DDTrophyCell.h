//
//  DDTrophyCell.h
//  iTaskFamily
//
//  Created by Damien DELES on 02/12/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DDCustomProgressBar;

@interface DDTrophyCell : UITableViewCell


#pragma mark - Variables

//Label du nom de la catégorie
@property (weak, nonatomic) IBOutlet UILabel *labelName;

//Label du nombre d'occurence réalisée
@property (weak, nonatomic) IBOutlet UILabel *labelOccurenceRealised;

//Label du nombre total d'occurence
@property (weak, nonatomic) IBOutlet UILabel *labelTotalOccurence;

//ProgressBar des réalisations
@property (weak, nonatomic) IBOutlet DDCustomProgressBar *progressBar;


@end
