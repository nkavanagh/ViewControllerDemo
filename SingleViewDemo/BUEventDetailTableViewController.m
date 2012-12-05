//
//  BUEventDetailTableViewController.m
//  SingleViewDemo
//
//  Created by Niall Kavanagh on 12/5/12.
//  Copyright (c) 2012 Boston University. All rights reserved.
//

#import "BUEventDetailTableViewController.h"

@interface BUEventDetailTableViewController ()

@end

@implementation BUEventDetailTableViewController

@synthesize summaryLabel;
@synthesize timeLabel;
@synthesize descriptionLabel;
@synthesize locationLabel;
@synthesize emailLabel;
@synthesize phoneLabel;
@synthesize eventID;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    NSString *uri = [NSString stringWithFormat:@"http://www.bu.edu/bumobile/rpc/calendar/events.json.php?eid=%@", eventID];
    NSLog(@"Loading %@", uri);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:uri]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"There was a problem fetching the event: %@", error);
        } else if (data) {
            NSDictionary *decodedResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:NSJSONReadingMutableContainers
                                                                              error:nil];
            
            NSDictionary *resultSet = [decodedResponse objectForKey:@"ResultSet"];
            
            NSDictionary *event = [resultSet[@"Result"] firstObject];
            
            NSLog(@"event: %@", event);
            summaryLabel.text = event[@"summary"];
            timeLabel.text = [NSString stringWithFormat:@"%@; %@", event[@"displayTime"], event[@"displayDate"]];
            descriptionLabel.text = event[@"description"];
            locationLabel.text = event[@"location"];
            phoneLabel.text = event[@"phone"];
            emailLabel.text = event[@"contactEmail"];
            [self.tableView reloadData];
            
        } else {
            NSLog(@"There was no event data!");
        }
    }];

    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
