//
//  MSStopTime.m
//  BuzzStop
//
//  Created by Alex Eckermann on 12/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import "MSStopTime.h"

@implementation MSStopTime

- (instancetype)initWithStop:(MSStop *)stop arriviesAt:(NSDate *)arrivesAt {
    self = [super init];
    if (self) {
        self.stop = stop;
        self.arrivesAt = arrivesAt;
    }
    return self;
}

@end
