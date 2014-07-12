//
//  MSStopViewController.h
//  BuzzStop
//
//  Created by Alex Eckermann on 12/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSStop;

@interface MSStopViewController : UITableViewController

@property (strong, nonatomic) MSStop *stop;

@property (weak, nonatomic) IBOutlet UILabel *stopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stopDetailLabel;

@end
