//
//  MSStopNotificationActionTableViewCell.h
//  BuzzStop
//
//  Created by Alex Eckermann on 13/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSStopNotificationActionTableViewCell : UITableViewCell

@property (readwrite, nonatomic) BOOL notifyOnApproach;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

- (IBAction)didTapActionButton:(id)sender;

@end
