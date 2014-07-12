//
//  MSServiceBasicTableViewCell.m
//  BuzzStop
//
//  Created by Alex Eckermann on 12/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import "MSServiceBasicTableViewCell.h"

#import "MSService.h"

@interface MSServiceBasicTableViewCell ()
@property (readwrite, nonatomic) BOOL hasRendered;
@end

@implementation MSServiceBasicTableViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.hasRendered = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.hasRendered = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.hasRendered = YES;
    
    [self renderContent];
}

- (void)setService:(MSService *)service {
    
    [self willChangeValueForKey:@"service"];
    _service = service;
    [self didChangeValueForKey:@"service"];

    [self renderContent];
    if (!self.hasRendered) {
        [self setNeedsLayout];
    }
    
}

- (void)renderContent {
    
    self.serviceCodeLabel.text = self.service.routeCode;
    self.serviceNameLabel.text = self.service.destination;
    
    NSNumber *arrivalTimeNumber = @([self.service.arrivesAt timeIntervalSinceNow] / 60);
    
    self.serviceArrivalLabel.text = [NSString stringWithFormat:@"%li min", (long)[arrivalTimeNumber integerValue]];
    
}

@end
