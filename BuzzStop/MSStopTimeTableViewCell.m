//
//  MSStopTimeTableViewCell.m
//  BuzzStop
//
//  Created by Alex Eckermann on 12/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import "MSStopTimeTableViewCell.h"
#import "MSStopTime.h"
#import "MSStop.h"

@interface MSStopTimeTableViewCell ()
@property (readwrite, nonatomic) BOOL hasRendered;
@end

@implementation MSStopTimeTableViewCell

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
    
    if ([self.stopTime.arrivesAt timeIntervalSinceNow] < 0) {
        self.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    
    [self renderContent];
}

- (void)setStopTime:(MSStopTime *)stopTime {
    if ([stopTime isEqual: _stopTime]) return;
    
    [self willChangeValueForKey:@"stopTime"];
    _stopTime = stopTime;
    [self didChangeValueForKey:@"stopTime"];
    
    [self renderContent];
    if (!self.hasRendered) {
        [self setNeedsLayout];
    }
    
}

- (void)renderContent {
    
    self.stopNameLabel.text = self.stopTime.stop.name;
    self.stopArrivalLabel.text = [self minutesTillArrivalString];
    self.stopDetailLabel.text = self.stopTime.stop.interestingDescription;
    
}

- (NSString *)minutesTillArrivalString {
    
    if (!self.stopTime.arrivesAt) return @"???";
    
    NSTimeInterval intervalTillArrival = [self.stopTime.arrivesAt timeIntervalSinceNow];
    
    if (intervalTillArrival < 0) {
        return [NSString stringWithFormat:@"%lu\nmins ago", (long)(intervalTillArrival / 60)];
    } else if (intervalTillArrival > 1) {
        return [NSString stringWithFormat:@"%lu\nmins", (long)(intervalTillArrival / 60)];
    }
    
    return @"now";
}

@end
