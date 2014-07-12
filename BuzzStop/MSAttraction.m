//
//  MSAttraction.m
//  BuzzStop
//
//  Created by Alex Eckermann on 12/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import "MSAttraction.h"

@implementation MSAttraction

- (instancetype)initWithJSONData:(NSDictionary *)json {
    self = [super init];
    if(self) {
        self.name = json[@"name"];
        self.attractionDescription = json[@"description"];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        self.distance = [numberFormatter numberFromString: json[@"distance"]];
        
        self.imageURL = [NSURL URLWithString:json[@"product_image"]];
    }
    return self;
}

@end
