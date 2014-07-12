//
//  MSDirector.m
//  BuzzStop
//
//  Created by Alex Eckermann on 12/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import "MSDirector.h"
#import <AFNetworking.h>

#import "MSStop.h"

@import CoreLocation;

static NSString * const MSStopBeaconRegionUUIDString = @"ADE7A1DE-DFFB-48D2-B060-D0F5A71096E0";
static NSString * const MSVehicleBeaconRegionUUIDString = @"ADE7A1DE-FDDB-48D2-B060-D0F5A71096E0";

static NSString * const MSAPIBaseURLString = @"http://ec2-54-79-18-236.ap-southeast-2.compute.amazonaws.com/";

@interface MSDirector ()
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLBeaconRegion *stopBeaconRegion;
@property (strong, nonatomic) CLBeaconRegion *vehicleBeaconRegion;

@property (strong, nonatomic) MSStop *currentStop;
@property (strong, nonatomic) CLBeacon *currentStopBeacon;

@property (strong, nonatomic) NSObject *currentVehicle;
@property (strong, nonatomic) CLBeacon *currentVehicleBeacon;

@property (strong, nonatomic) MSTrip *currentTrip;

@property (strong, nonatomic) AFHTTPRequestOperationManager *apiRequestManager;

@property (readwrite, nonatomic) dispatch_queue_t callbackQueue;

@end

@implementation MSDirector

+ (MSDirector *)sharedDirector {
    static MSDirector *_director = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _director = [[MSDirector alloc] init];
    });
    return _director;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        
        NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString: MSStopBeaconRegionUUIDString];
        self.stopBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconUUID identifier:@"com.moonshine.busstop"];
        beaconUUID = [[NSUUID alloc] initWithUUIDString: MSVehicleBeaconRegionUUIDString];
        self.vehicleBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconUUID identifier:@"com.moonshine.vehicle"];
        
        self.apiRequestManager = [AFHTTPRequestOperationManager manager];
        
        self.callbackQueue = dispatch_queue_create("com.moonshine.directorcallbacks", kNilOptions);
    }
    return self;
}

- (void)startMonitoringForContext {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.locationManager startMonitoringForRegion: self.stopBeaconRegion];
}

- (void)stopMonitoringForContext {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.locationManager stopMonitoringForRegion:self.stopBeaconRegion];
}

- (void)startRangingStops {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.locationManager startRangingBeaconsInRegion: self.stopBeaconRegion];
}

- (void)stopRangingStops {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.locationManager stopRangingBeaconsInRegion: self.stopBeaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"%s region: %@", __PRETTY_FUNCTION__, region);
    
    if([region isEqual: self.stopBeaconRegion]) {
        [self startRangingStops];
    } else if ([region isEqual: self.vehicleBeaconRegion]) {
        
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"%s region: %@", __PRETTY_FUNCTION__, region);
    
    if([region isEqual: self.stopBeaconRegion]) {
        self.currentStop = self.currentStopBeacon = nil;
    } else if ([region isEqual: self.vehicleBeaconRegion]) {
        
    }
    
}

- (void)setCurrentStopBeacon:(CLBeacon *)currentStopBeacon {
    NSLog(@"%s beacon: %@", __PRETTY_FUNCTION__, currentStopBeacon);
    
    if (currentStopBeacon && [_currentStopBeacon.major isEqualToNumber: currentStopBeacon.major] &&
        [_currentStopBeacon.minor isEqualToNumber: currentStopBeacon.minor]) {
        return;
    }
    
    __block CLBeacon *previousStopBeacon = _currentStopBeacon;
    __weak MSDirector *wself = self;
    
    [self jsonForStopWithIdentifier:[currentStopBeacon.major stringValue] callback:^(BOOL success, NSDictionary *data) {
        NSLog(@"%s success: %i - json: %@", __PRETTY_FUNCTION__, success, data);
        if (success == YES) {
            MSStop *stop = [[MSStop alloc] initWithJSONData: data];
            
            if (stop != nil) {
                [wself willChangeValueForKey:@"currentStopBeacon"];
                _currentStopBeacon = currentStopBeacon;
                [wself didChangeValueForKey:@"currentStopBeacon"];
                wself.currentStop = stop;
                
                dispatch_async(dispatch_get_main_queue(), ^{ [NSNotificationCenter.defaultCenter postNotificationName:MSDirectorDidChangeCurrentStopNotification object:nil userInfo:nil]; });
                
            }

        }
    }];
    
    [self stopRangingStops];
    
}

- (void)jsonForStopWithIdentifier:(NSString *)identifier callback:(void (^)(BOOL success, NSDictionary *data))callback {
    
    [self.apiRequestManager GET:MSAPIBaseURLString parameters:@{ @"method": @"stop", @"q": identifier } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        dispatch_async(self.callbackQueue, ^{ callback(YES, responseObject); });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(self.callbackQueue, ^{ callback(NO, nil); });
    }];
    
}

- (void)jsonForTripStopsWithIdentifier:(NSString *)identifier startingFrom:(NSString *)originStopIdentifier callback:(void (^)(BOOL success, NSDictionary *data))callback {
    
    NSString *queryString = [NSString stringWithFormat:@"%@,%@", identifier, originStopIdentifier];
    
    [self.apiRequestManager GET:MSAPIBaseURLString parameters:@{ @"method": @"trip_stops", @"q": queryString } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        dispatch_async(self.callbackQueue, ^{ callback(YES, responseObject); });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(self.callbackQueue, ^{ callback(NO, nil); });
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    NSLog(@"%s region: %@ - beacons.count: %lu", __PRETTY_FUNCTION__, region, (unsigned long)[beacons count]);
    
    if ([region isEqual: self.stopBeaconRegion]) {
        CLBeacon *closestBeacon = self.currentStopBeacon;
        
        for (CLBeacon *beacon in beacons) {
            if (!closestBeacon || beacon.accuracy < closestBeacon.accuracy) {
                closestBeacon = beacon;
            }
        }
        
        if (closestBeacon) {
            self.currentStopBeacon = closestBeacon;
        }
        
    }
    
    
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    
    if ([region isEqual: self.stopBeaconRegion] && state == CLRegionStateInside) {
        [self startRangingStops];
    }
    
}

@end
