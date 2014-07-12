//
//  MSWelcomeAboardViewController.h
//  BuzzStop
//
//  Created by Alex Eckermann on 13/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSService, GPUImageiOSBlurFilter;

@interface MSWelcomeAboardViewController : UIViewController

@property (strong, nonatomic) MSService *service;

@property (weak, nonatomic) IBOutlet UILabel *serviceCodeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (strong, nonatomic) UIImage *blurredBackgroundImage;

+ (UIImage *)blurImage:(UIImage *)image;

@end
