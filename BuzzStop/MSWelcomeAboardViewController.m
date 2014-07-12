//
//  MSWelcomeAboardViewController.m
//  BuzzStop
//
//  Created by Alex Eckermann on 13/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import "MSWelcomeAboardViewController.h"
#import "MSService.h"
#import "GPUImage.h"

@interface MSWelcomeAboardViewController ()

@end

@implementation MSWelcomeAboardViewController

+ (GPUImageiOSBlurFilter *)sharedBlurFilter {
    static GPUImageiOSBlurFilter *_filter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _filter = [GPUImageiOSBlurFilter new];
        _filter.blurRadiusInPixels = 3.0;
        _filter.saturation = 0.0;
    });
    
    return _filter;
}

+ (UIImage *)blurImage:(UIImage *)image {
    return [self.sharedBlurFilter imageByFilteringImage:image];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.serviceCodeLabel.text = self.service.routeCode;
    self.backgroundImageView.image = self.blurredBackgroundImage;
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(mc_applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

- (void)mc_applicationDidBecomeActive:(NSNotification *)notification {
    
    [self performSelector:@selector(shutThisWholeThingDown) withObject:nil afterDelay:3];
    
}

- (void)shutThisWholeThingDown {
    
    [NSNotificationCenter.defaultCenter removeObserver: self];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
