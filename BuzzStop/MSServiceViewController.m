//
//  MSServiceViewController.m
//  BuzzStop
//
//  Created by Alex Eckermann on 12/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import "MSServiceViewController.h"

#import "MSDirector.h"
#import "MSService.h"
#import "MSStopTime.h"
#import "MSTrip.h"
#import "MSStop.h"
#import "MSStopTimeTableViewCell.h"
#import "MSWelcomeAboardViewController.h"

@interface MSServiceViewController ()
@property (strong, nonatomic) NSArray *tripStopTimes;
@property (strong, nonatomic) UIImage *blurredContentImage;
@end

@implementation MSServiceViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.serviceCodeLabel.text = self.service.routeCode;
    self.serviceNameLabel.text = self.service.destination;
    
    if (!self.tripStopTimes) {
        [self fetchTripStopTimes];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(mc_applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    CGRect snapshotBounds = self.view.frame;
    UIGraphicsBeginImageContext(snapshotBounds.size);
    [self.view drawViewHierarchyInRect:snapshotBounds afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.blurredContentImage = [MSWelcomeAboardViewController blurImage:snapshotImage];
    
}

- (void)mc_applicationWillResignActive:(NSNotification *)notification {
    
    [self performSegueWithIdentifier:@"WelcomeAboard" sender:nil];
    [NSNotificationCenter.defaultCenter removeObserver: self];
    
}

- (void)fetchTripStopTimes {
    __weak MSServiceViewController *wself = self;
    [MSDirector.sharedDirector jsonForTripStopsWithIdentifier:self.service.trip.identifier startingFrom:self.originatingStop.identifier callback:^(BOOL success, NSDictionary *data) {
        if (success) {
            NSArray *stops = data[@"stops"];
            NSMutableArray *tripStopTimes = [NSMutableArray array];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDefaultDate:[NSDate date]];
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            
            for (NSDictionary *stopData in stops) {
                
                MSStop *stop = [[MSStop alloc] initWithJSONData:stopData];
                NSDate *arrivesAt = [dateFormatter dateFromString: stopData[@"arrival_time"]];
                MSStopTime *stopTime = [[MSStopTime alloc] initWithStop:stop arriviesAt:arrivesAt];
                
                [tripStopTimes addObject:stopTime];
                
            }
            
            wself.tripStopTimes = [NSArray arrayWithArray: tripStopTimes];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [wself.tableView reloadData];
            });
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.tripStopTimes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MSStopTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StopCell" forIndexPath:indexPath];
    
    cell.stopTime = self.tripStopTimes[indexPath.row];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString: @"WelcomeAboard"]) {
        MSWelcomeAboardViewController *welcomeAboardViewController = (MSWelcomeAboardViewController *)segue.destinationViewController;
        welcomeAboardViewController.blurredBackgroundImage = self.blurredContentImage;
        welcomeAboardViewController.service = self.service;
    }
    
}


@end
