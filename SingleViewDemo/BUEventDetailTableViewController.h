//
//  BUEventDetailTableViewController.h
//  SingleViewDemo
//
//  Created by Niall Kavanagh on 12/5/12.
//  Copyright (c) 2012 Boston University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BUEventDetailTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property NSNumber *eventID;

@end
