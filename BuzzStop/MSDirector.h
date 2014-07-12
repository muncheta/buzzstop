//
//  MSDirector.h
//  BuzzStop
//
//  Created by Alex Eckermann on 12/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CLLocationManagerDelegate;
@class MSStop, MSTrip;

static NSString * const MSDirectorDidChangeCurrentStopNotification = @"notifMSDirectorDidChangeCurrentStop";

@interface MSDirector : NSObject <CLLocationManagerDelegate>

@property (readonly, nonatomic) MSStop *currentStop;
@property (readonly, nonatomic) MSTrip *currentTrip;

+ (MSDirector *)sharedDirector;

- (void)startMonitoringForContext;
- (void)stopMonitoringForContext;

- (void)jsonForStopWithIdentifier:(NSString *)identifier callback:(void (^)(BOOL success, NSDictionary *data))callback;
- (void)jsonForTripStopsWithIdentifier:(NSString *)identifier startingFrom:(NSString *)originStopIdentifier callback:(void (^)(BOOL success, NSDictionary *data))callback;


@end
