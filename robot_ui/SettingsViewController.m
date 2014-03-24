//
//  SettingsViewController.m
//  robot_ui
//
//  Created by Akansel Cosgun on 3/23/14.
//  Copyright (c) 2014 Akansel Cosgun. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *human_centered_switch;
@property (weak, nonatomic) IBOutlet UITextField *ip_textfield;
@property (weak, nonatomic) IBOutlet UISwitch *device_id_switch;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_ip_textfield.text forKey:@"prev_ip_add"];
    [defaults synchronize];
    
    //Notify RemoteControlViewController
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ip" object:self];
    
    [textField resignFirstResponder];
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _ip_textfield.delegate = self;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *prev_ip_add =[prefs stringForKey:@"prev_ip_add"];
    BOOL prev_device_id =[prefs boolForKey:@"prev_device_id"];
    BOOL prev_human_centered =[prefs boolForKey:@"prev_human_centered"];
	
    _ip_textfield.text = prev_ip_add;
    _human_centered_switch.on=prev_human_centered;
    _device_id_switch.on=prev_device_id;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)newDeviceID:(id)sender {
    
    NSLog(@"Saved Device ID");
    //Save the selection
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:_device_id_switch.isOn forKey:@"prev_device_id"];
    [defaults synchronize];
    
    //Notify RemoteControlViewController
    [[NSNotificationCenter defaultCenter] postNotificationName:@"device" object:self];
}

- (IBAction)newUserCentered:(id)sender {

    //NSLog(@"Saved UserCentered");
    
    //Save the selection
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:_human_centered_switch.isOn forKey:@"prev_human_centered"];
    [defaults synchronize];
    
    //Notify RemoteControlViewController
    [[NSNotificationCenter defaultCenter] postNotificationName:@"usr_cntr" object:self];
}

@end
