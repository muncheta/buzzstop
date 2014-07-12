//
//  MSTrip.h
//  BuzzStop
//
//  Created by Alex Eckermann on 12/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSTrip : NSObject

@property (strong, nonatomic) NSString *identifier;

- (instancetype)initWithIdentifier:(NSString *)identifier;

@end
