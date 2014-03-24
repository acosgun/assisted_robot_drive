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
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation RemoteControlViewController{
    UDP_helper *udp_node;
    bool socket_success;
    NSString *ip_add;
    BOOL human_centered;
    BOOL is_users_device;
}
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
    is_running = true;
    if (is_running) {
        instruction_label.hidden = YES;
        
        currentPitch = degrees(Attitude.pitch);
        currentRoll = degrees(Attitude.roll);
        currentYaw  = degrees(Attitude.yaw);

        
        //send data
        NSMutableData * out_data = [NSMutableData dataWithCapacity: 0];
        
        
        Byte mode = 0;
        
        if(human_centered)
        {
            mode = mode + (Byte) 100;
        }
        if(is_users_device)
        {
            mode = mode + (Byte) 1;
        }
        
        
        [out_data appendBytes:&mode length:sizeof(Byte)];
        [out_data appendBytes:&currentRoll length:sizeof(float)];
        [out_data appendBytes:&currentPitch length:sizeof(float)];
        [out_data appendBytes:&currentMagHeading length:sizeof(float)];
        if(socket_success)
        {
            [udp_node send:out_data];
        }

        
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

    [self initLocationManager];
    [self updateIP];
    [self updateUserCentered];
    [self updateDeviceID];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"ip"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"usr_cntr"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"device"
                                               object:nil];
    
    
    distance = 1;
    is_connected = YES;
    distance_label.transform = CGAffineTransformMakeRotation(-90 * M_PI / 180.0);
    instruction_label.transform = CGAffineTransformMakeRotation(-90 * M_PI / 180.0);
    distance_label.hidden = YES;
    
    MotionManager = ([[CMMotionManager alloc]init]);
    MotionManager.deviceMotionUpdateInterval = 1/60;
    [MotionManager startDeviceMotionUpdates];
    
    timer1 = [NSTimer scheduledTimerWithTimeInterval:1/60 target:self selector:@selector(Running) userInfo:nil repeats:YES];


    socket_success = [self initialize_UDP];
}

- (void)receivedNotification:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:@"ip"])
    {
        [self updateIP];
        socket_success = [self initialize_UDP];
    }
    else if ([[notification name] isEqualToString:@"usr_cntr"])
    {
        [self updateUserCentered];
    }
    else if ([[notification name] isEqualToString:@"device"])
    {
        [self updateDeviceID];
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    currentTrueHeading= (float) newHeading.magneticHeading;
    currentMagHeading = (float) newHeading.trueHeading;
}

- (void) updateIP
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    ip_add =[prefs stringForKey:@"prev_ip_add"];
}

- (void) updateDeviceID
{
    NSLog(@"Updating Device ID");
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    is_users_device =[prefs boolForKey:@"prev_device_id"];
}

- (void) updateUserCentered
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    human_centered =[prefs boolForKey:@"prev_human_centered"];
}

- (bool) initialize_UDP
{
    udp_node= [UDP_helper new];
    //NSString* ip_add = @"192.168.1.19";
    int port_num = 7575;
    return [udp_node initializeSocket:ip_add port:port_num];
    
}

- (void) initLocationManager
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [_locationManager startUpdatingHeading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
