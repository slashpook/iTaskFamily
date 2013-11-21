//
//  DDHelperController.m
//  iTaskFamily
//
//  Created by Damien DELES on 21/11/2013.
//  Copyright (c) 2013 Damien DELES. All rights reserved.
//

#import "DDHelperController.h"

@implementation DDHelperController


#pragma mark - Controller fonctions

//Retourne un snapshot d'une partie de l'écran
+ (UIImage *)snapshotFromImage:(UIImage *)imageOriginal withRect:(CGRect)frameSnapshot
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageOriginal CGImage], frameSnapshot);
    UIImage *imageSnapshot = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return imageSnapshot;
}

@end
