//
//  MSStopDetailViewController.h
//  BuzzStop
//
//  Created by Alex Eckermann on 13/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSStop;

@interface MSStopDetailViewController : UITableViewController

@property (strong, nonatomic) MSStop *stop;

@property (weak, nonatomic) IBOutlet UILabel *stopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stopDetailLabel;

- (IBAction)didTapBackButton:(id)sender;

@end
