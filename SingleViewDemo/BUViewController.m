//
//  BUViewController.m
//  SingleViewDemo
//
//  Created by Niall Kavanagh on 12/5/12.
//  Copyright (c) 2012 Boston University. All rights reserved.
//

#import "BUViewController.h"

@interface BUViewController ()

@end

@implementation BUViewController

@synthesize webView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.bu.edu/today"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
