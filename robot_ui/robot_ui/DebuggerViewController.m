//
//  DebuggerViewController.m
//  robot_ui
//
//  Created by Arnold Maliki on 3/17/14.
//  Copyright (c) 2014 Akansel Cosgun. All rights reserved.
//

#import "DebuggerViewController.h"

#define degrees(x) (180 * x / M_PI)

@interface DebuggerViewController ()

@end

@implementation DebuggerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)Running{
    CMAttitude * Attitude;
    CMDeviceMotion *motion = MotionManager.deviceMotion;
    Attitude = motion.attitude;
    
    currentPitch = degrees(Attitude.pitch);
    currentRoll = degrees(Attitude.roll);
    currentYaw  = degrees(Attitude.yaw);
    
    pitch.text = [NSString stringWithFormat:@"Pitch: %.01f\u00B0", currentPitch];
    roll.text = [NSString stringWithFormat:@"Roll: %.01f\u00B0", currentRoll];
    yaw.text = [NSString stringWithFormat:@"Yaw: %.01f\u00B0", currentYaw];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MotionManager = ([[CMMotionManager alloc]init]);
    MotionManager.deviceMotionUpdateInterval = 1/60;
    [MotionManager startDeviceMotionUpdates];
    
    timer2 = [NSTimer scheduledTimerWithTimeInterval:1/60 target:self selector:@selector(Running) userInfo:nil repeats:YES];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
