//
//  UIImage+CustomImage.h
//  ITaskFamily
//
//  Created by DAMIEN DELES on 04/04/12.
//  Copyright (c) 2012 INGESUP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CustomImage)


#pragma mark - Fonctions

//On croppe les images
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end
