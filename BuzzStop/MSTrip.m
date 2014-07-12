//
//  MSTrip.m
//  BuzzStop
//
//  Created by Alex Eckermann on 12/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import "MSTrip.h"

@interface MSTrip ()
@property (strong, nonatomic) NSArray *cachedStops;
@end

@implementation MSTrip

- (instancetype)initWithIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        self.identifier = identifier;
    }
    
    return self;
}

// Async stop fetch

@end
