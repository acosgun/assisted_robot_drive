//
//  DebuggerViewController.h
//  robot_ui
//
//  Created by Arnold Maliki on 3/17/14.
//  Copyright (c) 2014 Akansel Cosgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <AudioToolbox/AudioToolbox.h>

CMMotionManager *MotionManager;
float currentPitch;
float currentRoll;
float currentYaw;


@interface DebuggerViewController : UIViewController

{
    NSTimer *timer2;
    IBOutlet UILabel * pitch;
    IBOutlet UILabel * roll;
    IBOutlet UILabel * yaw;
}


-(void)Running;
@end
