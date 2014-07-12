//
//  MSServiceBasicTableViewCell.h
//  BuzzStop
//
//  Created by Alex Eckermann on 12/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSService;

@interface MSServiceBasicTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *serviceCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceArrivalLabel;

@property (strong, nonatomic) MSService *service;

@end
