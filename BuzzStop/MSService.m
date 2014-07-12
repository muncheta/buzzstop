//
//  MSService.m
//  BuzzStop
//
//  Created by Alex Eckermann on 12/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import "MSService.h"
#import "MSTrip.h"
#import "MSDirector.h"

@interface MSService ()
@end

@implementation MSService

- (instancetype)initWithJSONData:(NSDictionary *)json {
    self = [super init];
    if(self) {
        self.routeCode = json[@"route_code"];
        self.destination = json[@"destination"];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        NSNumber *arrivesNumber = [numberFormatter numberFromString: json[@"arrives"]];
        NSDate *arrivesAtDate = [NSDate dateWithTimeIntervalSinceNow: [arrivesNumber intValue] * 60];
        self.arrivesAt = arrivesAtDate;
        
        self.trip = [[MSTrip alloc] initWithIdentifier: json[@"trip"]];
        
    }
    return self;
}

@end
