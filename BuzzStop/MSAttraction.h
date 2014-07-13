//
//  MSAttraction.h
//  BuzzStop
//
//  Created by Alex Eckermann on 12/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSAttraction : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *attractionDescription;
@property (strong, nonatomic) NSNumber *distance;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) UIImage *image;

- (instancetype)initWithJSONData:(NSDictionary *)json;

@end
