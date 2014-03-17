//
//  RemoteControlViewController.m
//  robot_ui
//
//  Created by Akansel Cosgun on 2/26/14.
//  Copyright (c) 2014 Akansel Cosgun. All rights reserved.
//

#import "RemoteControlViewController.h"

@interface RemoteControlViewController ()
// Outlets and actions here.
@end

@implementation RemoteControlViewController
// Implementation of the privately declared category must go here.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //is_connected = TRUE;
    
    _connection_label.text = @"Connected";
    
    //_connection_label_2.text = @"Connected2";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
