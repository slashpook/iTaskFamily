//
//  DDDateView.h
//  iTaskFamily
//
//  Created by Damien DELES on 21/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDDateView : UIView


#pragma mark - Variables

//Image du haut de la vue
@property (weak, nonatomic)IBOutlet UIImageView *imageViewHeader;

//Label du jour de la semaine
@property (weak, nonatomic)IBOutlet UILabel *labelDay;

//Label du numéro du jour de la semaine
@property (weak, nonatomic)IBOutlet UILabel *labelNumberOfDay;

//Label du mois en cours
@property (weak, nonatomic)IBOutlet UILabel *labelMonth;

//Label de l'année en cours
@property (weak, nonatomic)IBOutlet UILabel *labelYear;

//Image de séparation du jour avec le mois
@property (weak, nonatomic)IBOutlet UIImageView *imageSeparatorDayMonth;

//Label de l'heure en cours
@property (weak, nonatomic)IBOutlet UILabel *labelHour;

//Label des minutes en cours
@property (weak, nonatomic)IBOutlet UILabel *labelMin;

//Label du :
@property (weak, nonatomic)IBOutlet UILabel *labelSeparatorHourMin;

//Image de séparation du jour avec les heures
@property (weak, nonatomic)IBOutlet UIImageView *imageSeparatorDayHour;


#pragma mark - Fonctions


@end
