//
//  MSStopTime.h
//  BuzzStop
//
//  Created by Alex Eckermann on 12/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSStop;

@interface MSStopTime : NSObject

@property (strong, nonatomic) MSStop *stop;
@property (strong, nonatomic) NSDate *arrivesAt;

- (instancetype)initWithStop:(MSStop *)stop arriviesAt:(NSDate *)arrivesAt;

@end
