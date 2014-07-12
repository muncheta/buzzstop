//
//  MSLoadingViewController.m
//  BuzzStop
//
//  Created by Alex Eckermann on 12/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import "MSLoadingViewController.h"

#import "MSDirector.h"
#import "MSStopViewController.h"

@interface MSLoadingViewController ()

@end

@implementation MSLoadingViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didChangeCurrentStop:) name:MSDirectorDidChangeCurrentStopNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [NSNotificationCenter.defaultCenter removeObserver: self];
}

- (void)didChangeCurrentStop:(NSNotification *)notification {
    [self performSegueWithIdentifier:@"ShowStop" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowStop"]) {
        MSStopViewController *stopViewController = (MSStopViewController *)segue.destinationViewController;
        stopViewController.stop = [MSDirector.sharedDirector currentStop];
    }
    
}

@end
