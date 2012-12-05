//
//  BUEventDetailTableViewController.h
//  SingleViewDemo
//
//  Created by Niall Kavanagh on 12/5/12.
//  Copyright (c) 2012 Boston University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BUEventDetailTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITableViewCell *summaryLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *timeLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *phoneLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *emailLabel;
@property NSNumber *eventID;

@end
