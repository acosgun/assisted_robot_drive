//
//  RemoteControlViewController.h
//  robot_ui
//
//  Created by Akansel Cosgun, Kaya Demir, Arnold Maliki on 2/26/14.
//  Copyright (c) 2014 Akansel Cosgun, Kaya Demir, Arnold Maliki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UDP_helper.h"
#import <CoreLocation/CoreLocation.h>

#import "SettingsViewController.h"

BOOL is_connected;
BOOL is_running = NO;
BOOL is_vibrate = NO;
extern BOOL is_on_screen;
BOOL is_instruction_hidden = false;
CMMotionManager *MotionManager;
float currentPitch;
float currentRoll;
float currentYaw;
float currentTrueHeading;
float currentMagHeading;
float speed;
float xloc;
float xcenter;
UITouch *touch;
CGPoint location_on_touch;
float distance;
float counter;

@interface RemoteControlViewController : UIViewController <CLLocationManagerDelegate>
{
    IBOutlet UILabel *distance_label;
    IBOutlet UILabel *instruction_label;
    IBOutlet UIImageView *slider;
    NSTimer *timer1;

}


-(void)Running;
-(void)Vibrate;

@end
