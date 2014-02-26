//
//  Main Window.h
//  RoboTracking
//
//  Created by Arnold Maliki on 2/23/14.
//  Copyright (c) 2014 Arnold Maliki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMotion/CoreMotion.h>
#include <math.h>

BOOL isGo;
float currentTilt;
float currentRoll;
float currentAngle;
float currentSpeed;
float currentDistance;
BOOL isConnect;
NSString *IPAddress;
CMMotionManager *MotionManager;
float VibrateInterval;
float yellowrad;
float redrad;
float actualAngle;
float currentLoop;
BOOL VibrateOn;

@interface Main_Window : UIViewController

{
    
    IBOutlet UIButton *Start;
    IBOutlet UIButton *Connection;
    IBOutlet UILabel *Speed;
    IBOutlet UILabel *Distance;
    IBOutlet UILabel *Status;
    IBOutlet UILabel *IP;
    IBOutlet UILabel *Tilt;
    IBOutlet UILabel *Roll;
    IBOutlet UILabel *Speed2;
    
    
    IBOutlet UIImageView *Moving;
    IBOutlet UIImageView *Robot;
    IBOutlet UIImageView *RedLine;
    
    NSTimer *RepeatTimer;
    NSTimer *VibrateTimer;
    
}


-(void)empty;
-(IBAction)Start:(id)sender;
-(IBAction)Connection:(id)sender;
-(void)CheckConnection;
-(void)ReadGyro;
-(void)UpdateAppearance;
-(void)Running;
-(void)Vibrate;

@end

