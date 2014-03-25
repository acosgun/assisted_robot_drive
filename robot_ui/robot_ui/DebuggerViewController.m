//
//  DebuggerViewController.m
//  robot_ui
//
//  Created by Kaya Demir, Akansel Cosgun, Arnold Maliki on 3/17/14.
//  Copyright (c) 2014 Kaya Demir, Akansel Cosgun, Arnold Maliki. All rights reserved.
//

#import "DebuggerViewController.h"
#import "UDP_helper.h"

#define degrees(x) (180 * x / M_PI)

@interface DebuggerViewController ()
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation DebuggerViewController {
    UDP_helper *udp_node;
    bool socket_success;
}

- (void) initLocationManager
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [_locationManager startUpdatingHeading];
}

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
    trueHeading.text = [NSString stringWithFormat:@"True Heading: %.01f\u00B0", currentTrueHeading];
    magneticHeading.text = [NSString stringWithFormat:@"Mag Heading: %.01f\u00B0", currentMagHeading];
    
    /*
    //send data
    NSMutableData * out_data = [NSMutableData dataWithCapacity: 0];
    Byte mode = 1;
    [out_data appendBytes:&mode length:sizeof(Byte)];
    [out_data appendBytes:&currentRoll length:sizeof(float)];
    [out_data appendBytes:&currentPitch length:sizeof(float)];
    [out_data appendBytes:&currentYaw length:sizeof(float)];

    
    if(socket_success)
    {
        [udp_node send:out_data];
    }
    
    //NSLog(@"sending");
    //[udp_node send:out_data ipAddress:ip_add port:port_num];
    */
}

- (void)viewDidLoad
{
    [self initLocationManager];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MotionManager = ([[CMMotionManager alloc]init]);
    MotionManager.deviceMotionUpdateInterval = 1/60; //1/60
    [MotionManager startDeviceMotionUpdates];
    
    timer2 = [NSTimer scheduledTimerWithTimeInterval:1/60 target:self selector:@selector(Running) userInfo:nil repeats:YES];
    
    //UDP initialization
    udp_node= [UDP_helper new];
    NSString* ip_add = @"192.168.1.19";
    int port_num = 7575;
    socket_success = [udp_node initializeSocket:ip_add port:port_num];
    is_on_screen = NO;

}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    currentTrueHeading= (float) newHeading.magneticHeading;
    currentMagHeading = (float) newHeading.trueHeading;
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
