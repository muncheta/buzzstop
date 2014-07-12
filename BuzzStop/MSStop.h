//
//  MSStop.h
//  BuzzStop
//
//  Created by Alex Eckermann on 12/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

@interface MSStop : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *stopDescription;
@property (readonly, nonatomic) CLLocationCoordinate2D location;
@property (readonly, nonatomic) BOOL wheelchairBoarding;

+ (MSStop *)cachedStopForIdentifier:(NSString *)identifier;

- (NSString *)interestingDescription;
- (NSArray *)nearbyAttractions;
- (NSArray *)nextServices;
- (instancetype)initWithJSONData:(NSDictionary *)json;

@end
