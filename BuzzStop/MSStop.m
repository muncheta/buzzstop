//
//  MSStop.m
//  BuzzStop
//
//  Created by Alex Eckermann on 12/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import "MSStop.h"

@interface MSStop ()
@property (readwrite) BOOL wheelchairBoarding;
@property (readwrite) CLLocationCoordinate2D location;
@end

@implementation MSStop

- (instancetype)initWithJSONData:(NSDictionary *)json {
    self = [super init];
    if(self) {
        self.name = json[@"stop_name"];
        self.stopDescription = json[@"stop_desc"];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        NSNumber *latitudeNumber = [numberFormatter numberFromString:json[@"stop_lat"]];
        NSNumber *longitudeNumber = [numberFormatter numberFromString:json[@"stop_lon"]];
        NSNumber *wheelchairBoardingNumber = [numberFormatter numberFromString:json[@"wheelchairBoarding"]];
        
        self.location = CLLocationCoordinate2DMake(latitudeNumber.doubleValue, longitudeNumber.doubleValue);
        self.wheelchairBoarding = [wheelchairBoardingNumber boolValue];
    }
    return self;
}

@end
