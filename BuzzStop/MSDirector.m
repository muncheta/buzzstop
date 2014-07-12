//
//  MSDirector.m
//  BuzzStop
//
//  Created by Alex Eckermann on 12/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import "MSDirector.h"

@import CoreLocation;

@implementation MSDirector

+ (MSDirector *)sharedDirector {
    static MSDirector *_director = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _director = [[MSDirector alloc] init];
    });
    return _director;
}


@end
