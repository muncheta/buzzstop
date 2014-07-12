//
//  MSStopDetailViewController.m
//  BuzzStop
//
//  Created by Alex Eckermann on 13/07/2014.
//  Copyright (c) 2014 Alex Eckermann. All rights reserved.
//

#import "MSStopDetailViewController.h"
#import "MSStopNotificationActionTableViewCell.h"
#import "MSServiceBasicTableViewCell.h"
#import "MSStop.h"
#import "MSAttraction.h"
#import "MSDirector.h"

@interface MSStopDetailViewController ()
@property (nonatomic, readwrite) BOOL notifyOnApproach;
@property (nonatomic, strong) NSArray *nextServices;
@property (nonatomic, strong) NSArray *nearbyAttractions;
@end

@implementation MSStopDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.nextServices = @[];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateContent];
    [self reloadData];
    
}

- (void)reloadData {
    
    __weak MSStopDetailViewController *wself = self;
    
    [MSDirector.sharedDirector jsonForStopWithIdentifier:self.stop.identifier callback:^(BOOL success, NSDictionary *data) {
        if (success) {
            MSStop *stop = [[MSStop alloc] initWithJSONData: data];
            dispatch_async(dispatch_get_main_queue(), ^{
                wself.stop = stop;
                [wself updateContent];
                [wself.tableView reloadData];
            });
        }
    }];
    
}

- (void)updateContent {
    
    self.stopNameLabel.text = self.stop.name;
    self.stopDetailLabel.text = self.stop.stopDescription;
    
    self.nextServices = self.stop.nextServices;
    self.nearbyAttractions = [self.stop nearbyAttractions];
    
}

- (IBAction)didTapBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (self.nearbyAttractions && self.nearbyAttractions.count > 0) {
        return 3;
    }
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1; // Notification button
    } else if (section == 1 && self.nearbyAttractions && self.nearbyAttractions.count > 0) {
        return MIN(self.nearbyAttractions.count, 3);
    }
    
    return self.nextServices.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else if (section == 1 && self.nearbyAttractions && self.nearbyAttractions.count > 0) {
        return @"Nearby Attractions";
    }
    
    return @"Next services";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self tableView:tableView notificationCellForIndexPath:indexPath];
    } else if (indexPath.section == 1 && self.nearbyAttractions && self.nearbyAttractions.count > 0) {
        return [self tableView:tableView attractionCellForIndexPath:indexPath];
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView notificationCellForIndexPath:(NSIndexPath *)indexPath {
    MSStopNotificationActionTableViewCell *cell = (MSStopNotificationActionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"NotificationCell" forIndexPath:indexPath];
    
    cell.notifyOnApproach = self.notifyOnApproach;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView attractionCellForIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttractionCell" forIndexPath:indexPath];
    
    MSAttraction *attraction = self.nearbyAttractions[indexPath.row];
    cell.textLabel.text = attraction.name;
    cell.detailTextLabel.text = attraction.attractionDescription;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, kNilOptions), ^{
        NSData *imageData = [NSData dataWithContentsOfURL: attraction.imageURL];
        if (imageData && imageData.length > 0) {
            UIImage *image = [UIImage imageWithData: imageData];
            cell.imageView.image = image;
        }
    });
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView serviceCellForIndexPath:(NSIndexPath *)indexPath {
    MSServiceBasicTableViewCell *cell = (MSServiceBasicTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ServiceCell" forIndexPath:indexPath];
    
    cell.service = self.nextServices[indexPath.row];
    
    return cell;
}

@end
