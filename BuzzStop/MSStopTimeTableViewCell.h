//
//  MSStopTimeTableViewCell.h
//  BuzzStop
//
//  Created by Alex Eckermann on 12/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSStopTime;

@interface MSStopTimeTableViewCell : UITableViewCell

@property (strong, nonatomic) MSStopTime *stopTime;

@property (weak, nonatomic) IBOutlet UILabel *stopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stopDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *stopArrivalLabel;

@end
