//
//  DebuggerViewController.h
//  robot_ui
//
//  Created by Kaya Demir, Akansel Cosgun, Arnold Maliki on 3/17/14.
//  Copyright (c) 2014 Kaya Demir, Akansel Cosgun, Arnold Maliki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreLocation/CoreLocation.h>

CMMotionManager *MotionManager;
float currentPitch;
float currentRoll;
float currentYaw;
float currentTrueHeading;
float currentMagHeading;

BOOL is_on_screen;



@interface DebuggerViewController : UIViewController <CLLocationManagerDelegate>

{
    NSTimer *timer2;
    IBOutlet UILabel * pitch;
    IBOutlet UILabel * roll;
    IBOutlet UILabel * yaw;
    IBOutlet UILabel * magneticHeading;
    IBOutlet UILabel * trueHeading;
}


-(void)Running;
@end
