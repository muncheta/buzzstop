//
//  MSServiceViewController.h
//  BuzzStop
//
//  Created by Alex Eckermann on 12/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSService, MSStop;

@interface MSServiceViewController : UITableViewController

@property (strong, nonatomic) MSStop *originatingStop;
@property (strong, nonatomic) MSService *service;

@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceDetailLabel;

@end
