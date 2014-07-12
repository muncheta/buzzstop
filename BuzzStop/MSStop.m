//
//  MSStop.m
//  BuzzStop
//
//  Created by Alex Eckermann on 12/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import "MSStop.h"
#import "MSAttraction.h"
#import "MSService.h"

//static NSMapTable *ms_stops = NULL;
//static dispatch_semaphore_t ms_stopsLock;

static NSMapTable *ms_stopAttractions = NULL;
static dispatch_semaphore_t ms_stopAttractionsLock;

@interface MSStop ()
@property (readwrite) BOOL wheelchairBoarding;
@property (readwrite) CLLocationCoordinate2D location;
@property (strong, nonatomic) NSMutableArray *nextServicesCollection;
@end

@implementation MSStop

- (void)_initMaps {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        ms_stopsLock = dispatch_semaphore_create(1);
//        ms_stops = [NSMapTable strongToStrongObjectsMapTable];
        ms_stopAttractionsLock = dispatch_semaphore_create(1);
        ms_stopAttractions = [NSMapTable strongToStrongObjectsMapTable];
    });
}

//+ (MSStop *)cachedStopForIdentifier:(NSString *)identifier {
//    MSStop *cachedStop = nil;
//    dispatch_semaphore_wait(ms_stopsLock, DISPATCH_TIME_FOREVER);
//    cachedStop = [ms_stops objectForKey:identifier];
//    dispatch_semaphore_signal(ms_stopsLock);
//    return cachedStop;
//}

- (instancetype)initWithJSONData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        [self _initMaps];
        NSDictionary *stopData = data;
        if ([data[@"stop"] isKindOfClass: [NSArray class]]) {
            stopData = ((NSArray *) data[@"stop"])[0];
        }
        self.identifier = stopData[@"stop_code"];
        self.name = stopData[@"stop_name"];
        self.stopDescription = stopData[@"stop_desc"];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        NSNumber *latitudeNumber = [numberFormatter numberFromString:stopData[@"stop_lat"]];
        NSNumber *longitudeNumber = [numberFormatter numberFromString:stopData[@"stop_lon"]];
        NSNumber *wheelchairBoardingNumber = [numberFormatter numberFromString:stopData[@"wheelchairBoarding"]];
        
        self.location = CLLocationCoordinate2DMake(latitudeNumber.doubleValue, longitudeNumber.doubleValue);
        self.wheelchairBoarding = [wheelchairBoardingNumber boolValue];
        
        NSArray *attractions = data[@"attractions"];
        if (attractions) {
            NSMutableArray *attractionsCollection = [NSMutableArray array];
            for (NSDictionary *attractionData in attractions) {
                MSAttraction *attraction = [[MSAttraction alloc] initWithJSONData: attractionData];
                [attractionsCollection addObject: attraction];
            }
            [MSStop cacheAttractions:attractionsCollection forStopWithIdentifier:self.identifier];
        }
        
        NSArray *nextServices = data[@"next_services"];
        if (nextServices) {
            self.nextServicesCollection = [NSMutableArray array];
            
            for (NSDictionary *serviceData in nextServices) {
                
                MSService *service = [[MSService alloc] initWithJSONData: serviceData];
                [self.nextServicesCollection addObject: service];
                
            }
        }
        
    }
    return self;
}

+ (void)cacheAttractions:(NSArray *)attractions forStopWithIdentifier:(NSString *)identifier {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, kNilOptions), ^{
        
        NSArray *sortedAttractions = [attractions sortedArrayUsingComparator:^NSComparisonResult(MSAttraction *attractionA, MSAttraction *attractionB) {
            if (attractionA.distance > attractionB.distance) {
                return NSOrderedDescending;
            } else if (attractionA.distance < attractionB.distance) {
                return NSOrderedAscending;
            }
            return NSOrderedSame;
        }];
        
        dispatch_semaphore_wait(ms_stopAttractionsLock, DISPATCH_TIME_FOREVER);
        [ms_stopAttractions setObject:sortedAttractions forKey:identifier];
        dispatch_semaphore_signal(ms_stopAttractionsLock);
        
    });
}

- (NSArray *)nearbyAttractions {
    
    dispatch_semaphore_wait(ms_stopAttractionsLock, DISPATCH_TIME_FOREVER);
    NSArray *attractions = [ms_stopAttractions objectForKey: self.identifier];
    dispatch_semaphore_signal(ms_stopAttractionsLock);
    
    return attractions;
}

- (NSString *)interestingDescription {
    NSArray *nearbyAttractions = [self nearbyAttractions];
    if (nearbyAttractions && [nearbyAttractions count] > 0) {
        NSMutableArray *interestingItems = [NSMutableArray array];
        for (int i = 0; i < nearbyAttractions.count && i < 3; i++) {
            MSAttraction *attraction = nearbyAttractions[i];
            [interestingItems addObject: attraction.name];
        }
        return [interestingItems componentsJoinedByString:@", "];
    }
    
    return self.stopDescription;
}

- (NSArray *)nextServices {
    
    NSArray *futureServices = [self.nextServicesCollection filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(MSService *service, NSDictionary *bindings) {
        return ([service.arrivesAt timeIntervalSinceNow] > 0);
    }]];
    
    NSArray *orderedFutureServices = [futureServices sortedArrayUsingComparator:^NSComparisonResult(MSService *serviceA, MSService *serviceB) {
        
        NSTimeInterval arrivalDifference = [serviceA.arrivesAt timeIntervalSinceDate: serviceB.arrivesAt];
        
        if (arrivalDifference > 0) {
            return NSOrderedDescending;
        } else if (arrivalDifference < 0) {
            return NSOrderedAscending;
        }
        
        return NSOrderedSame;
    }];
    
    return orderedFutureServices;
}

@end
