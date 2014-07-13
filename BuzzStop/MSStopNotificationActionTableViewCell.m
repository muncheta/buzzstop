//
//  MSStopNotificationActionTableViewCell.m
//  BuzzStop
//
//  Created by Alex Eckermann on 13/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import "MSStopNotificationActionTableViewCell.h"

@implementation MSStopNotificationActionTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateContent];
    
}

- (void)updateContent {
    
    if (self.notifyOnApproach) {
        [self.actionButton setTitle:@"Cancel approach alert" forState:UIControlStateNormal];
        [self.actionButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    } else {
        [self.actionButton setTitle:@"Notify on approach" forState:UIControlStateNormal];
        [self.actionButton setTitleColor:self.tintColor forState:UIControlStateNormal];
    }
    
}

- (IBAction)didTapActionButton:(id)sender {
    
    self.notifyOnApproach = !self.notifyOnApproach;
    [self updateContent];
    
    // Set up fake notification after delay
    // For presentation purposes only
    // This will eventually set up a geofence around the stop
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"You are approaching your stop";
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow: 35];
    
    [UIApplication.sharedApplication scheduleLocalNotification: notification];
    
}

@end
