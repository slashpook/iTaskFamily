//
//  DDCropperController.m
//  ITaskFamily
//
//  Created by DAMIEN DELES on 03/05/12.
//  Copyright (c) 2012 INGESUP. All rights reserved.
//

#define SHOW_PREVIEW NO

#import "DDCropperController.h"

@implementation DDCropperController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (id)initWithImage:(UIImage *)imageToCrop andDelegate:(id<DDCropperProtocol>)delegate
{
    self = [super init];
    if (self) {
        [self setImageToCrop:imageToCrop];
        [self setDelegate:delegate];
    }
    return self;
}


#pragma mark Fonction du controller

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //On customise les boutons et label
    [self.labelRedimensionner setFont:POLICE_CROPPER_TITLE];
    [self.buttonAnnuler.layer setCornerRadius:5.0];
    [self.buttonValider.titleLabel setFont:POLICE_CROPPER_BUTTON];
    [self.buttonValider.layer setCornerRadius:5.0];
    [self.buttonAnnuler.titleLabel setFont:POLICE_CROPPER_BUTTON];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //On charge l'image
    self.imageCropper = [[DDImageCropper alloc] init];
    [self.view addSubview:self.imageCropper];
    [self.imageCropper loadImage:self.imageToCrop withMaxSize:CGSizeMake(1024, 600)];
    self.imageCropper.center = self.view.center;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (IBAction)onPushAnnuler:(id)sender
{
    [self.imageCropper removeFromSuperview];
    [self.delegate cancelImage];
}

- (IBAction)onPushValider:(id)sender
{
    if ([self.imageCropper getCroppedImage] == nil)
    {
        [DDCustomAlertView displayErrorMessage:@"L'image redimensionnée est trop petite."];
    }
    else
    {
        [self.delegate validImage:[self.imageCropper getCroppedImage]];
        [self.imageCropper removeFromSuperview];
    }
}

@end
