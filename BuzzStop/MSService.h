//
//  MSService.h
//  BuzzStop
//
//  Created by Alex Eckermann on 12/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSTrip;

@interface MSService : NSObject

@property (strong, nonatomic) NSString *routeCode;
@property (strong, nonatomic) NSString *destination;
@property (strong, nonatomic) NSDate *arrivesAt;

@property (strong, nonatomic) MSTrip *trip;

- (instancetype)initWithJSONData:(NSDictionary *)json;

//- (void)trip:(void (^)(MSTrip *trip))callback;

@end
