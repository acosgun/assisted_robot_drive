//
//  RemoteControlViewController.m
//  robot_ui
//
//  Created by Akansel Cosgun, Kaya Demir, Arnold Maliki on 2/26/14.
//  Copyright (c) 2014 Akansel Cosgun, Kaya Demir, Arnold Maliki. All rights reserved.
//

#import "RemoteControlViewController.h"


#define degrees(x) (180 * x / M_PI)


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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    touch = [[event allTouches] anyObject];
    location_on_touch= [touch locationInView:self.view];
    xcenter = slider.center.x;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    is_running = YES;
    UITouch *drag = [[event allTouches] anyObject];
    CGPoint location_on_drag = [drag locationInView:self.view];
    xloc = xcenter + (location_on_drag.x - location_on_touch.x);
    if (xloc <= -250) {
        slider.center = CGPointMake(-250, slider.center.y);
    }
    else if (xloc >= 0) {
        slider.center = CGPointMake(0, slider.center.y);
    }
    else {
        slider.center = CGPointMake(xloc,slider.center.y);
    }
    
    //NSLog(@"on drag : %@", NSStringFromCGPoint(location_on_drag));
    //NSLog(@"initial : %@", NSStringFromCGPoint(location_on_touch));
    // NSLog(@"slider : %@", NSStringFromCGPoint(slider.center));
    //NSLog(@"xloc : %@", [NSString stringWithFormat:@"%1.6f", xloc]);
}


-(void)Running{
    CMAttitude * Attitude;
    CMDeviceMotion *motion = MotionManager.deviceMotion;
    Attitude = motion.attitude;
    
    if (is_running) {
        instruction_label.hidden = YES;
        
        currentPitch = degrees(Attitude.pitch);
        currentRoll = degrees(Attitude.roll);
        currentYaw  = degrees(Attitude.yaw);
    
        if (distance>2){
            distance_label.hidden = YES;
        }
        else {
            distance_label.hidden = NO;
            distance_label.text = [NSString stringWithFormat:@"%0.01f m", distance];
        }
    }
    //NSLog(@"is running : %@", [NSString stringWithFormat:@"%d", is_running]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    distance = 1;
    is_connected = YES;
    distance_label.transform = CGAffineTransformMakeRotation(-90 * M_PI / 180.0);
    instruction_label.transform = CGAffineTransformMakeRotation(-90 * M_PI / 180.0);
    distance_label.hidden = YES;
    
    MotionManager = ([[CMMotionManager alloc]init]);
    MotionManager.deviceMotionUpdateInterval = 1/60;
    [MotionManager startDeviceMotionUpdates];
    
    timer1 = [NSTimer scheduledTimerWithTimeInterval:1/60 target:self selector:@selector(Running) userInfo:nil repeats:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
