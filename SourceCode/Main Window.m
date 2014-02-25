//
//  Main Window.m
//  RoboTracking
//
//  Created by Arnold Maliki on 2/23/14.
//  Copyright (c) 2014 Arnold Maliki. All rights reserved.
//

#import "Main Window.h"

@interface Main_Window ()

@end

@implementation Main_Window


#define degrees(x) (180 * x / M_PI)

-(IBAction)Start:(id)sender{
    if (isGo == NO) {
        [Start setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
        isGo = YES;
    }
    else {
        [Start setImage:[UIImage imageNamed:@"run.png"] forState:UIControlStateNormal];
        isGo = NO;
    }
    
}


-(IBAction)Connection:(id)sender{
    isGo = NO;
    
    
}


-(void)CheckConnection{
    //ping and obtain data
    
    //if there is a response = connect,
    //obtain data: speed and distance to the wall.
    
    
    
    currentSpeed = 1;
    currentDistance = 1;
    actualAngle = 2*M_PI-0.3;
    
    IPAddress = @"192.168.1.1";
    
    
}

-(void)ReadGyro{
    CMAttitude * Attitude;
    CMDeviceMotion *motion = MotionManager.deviceMotion;
    Attitude = motion.attitude;
    
    currentRoll = degrees(Attitude.roll);
    currentTilt = degrees(Attitude.pitch);
    currentRoll = 20.012;
    currentTilt = 30.192;
    
    currentAngle = atan2f(currentTilt,currentRoll);
    currentAngle = 0;
    
    
    
}


-(void)UpdateAppearance{
    
    Roll.text = [NSString stringWithFormat:@"%.01f\u00B0", currentRoll];
    Tilt.text = [NSString stringWithFormat:@"%.01f\u00B0", currentTilt];
    Speed.text = [NSString stringWithFormat:@"%.01f", currentSpeed];
    Speed2.text = [NSString stringWithFormat:@"%.f", currentSpeed];
    Distance.text = [NSString stringWithFormat:@"%.01f", currentDistance];
    
    
    
    //color change and time timer for vibration
    if (currentDistance > 2){
        UIColor *color = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
        VibrateTimer = nil;
        UIImage *img = [UIImage imageNamed:@"robotgreen.png"];
        Robot.image = img;
        [Distance setTextColor:color];
    }
    
    else if ((currentDistance <= 2) && (currentDistance > 1)) {
        VibrateInterval = 2.5;
        UIImage *img = [UIImage imageNamed:@"robotred1.png"];
        Robot.image = img;
        
    }
    
    else if((currentDistance <= 1) && (currentDistance > 0.5)) {
        VibrateInterval = 1;
        UIImage *img = [UIImage imageNamed:@"robotred3.png"];
        Robot.image = img;
    }
    
    else if (currentDistance <= 0.2) {
        VibrateInterval = 0.5;
        UIImage *img = [UIImage imageNamed:@"robotred5.png"];
        [Robot setImage:img];
    }
    
    if (currentDistance < 2) {
        UIColor *color = [UIColor colorWithRed:255/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
        [Distance setTextColor:color];
        VibrateTimer = [NSTimer scheduledTimerWithTimeInterval:VibrateInterval target:self selector:@selector(Vibrate) userInfo:nil repeats:YES];
    }
    
    //rotate stuff
    Moving.center = CGPointMake(Robot.center.x+yellowrad*cosf(currentAngle),Robot.center.y-yellowrad*sinf(currentAngle));
    RedLine.center = CGPointMake(Robot.center.x+redrad*cosf(actualAngle),Robot.center.y-redrad*sinf(actualAngle));
    Speed2.center = CGPointMake(Robot.center.x+redrad*cosf(actualAngle),Robot.center.y-redrad*sinf(actualAngle));
       
    Moving.transform = CGAffineTransformMakeRotation(M_PI/2-currentAngle);
    RedLine.transform = CGAffineTransformMakeRotation(M_PI/2-actualAngle);
    Speed2.transform = CGAffineTransformMakeRotation(M_PI/2-actualAngle);
    

    
    
    //appear and disappear
    if (isGo == YES) {
        Moving.hidden = NO;
    }
    
    else {
        Moving.hidden = YES;
    }
    
    
    //update appearance connection
    if (isConnect==YES) {
        Status.text = @"Connected";
        IP.text = IPAddress;
    }
    
    else {
        Status.text = @"Disconnected";
        IP.text = @"N/A";
        //GIVE ALERT
    }
    
}

-(void)Vibrate{
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(void)Running{
    [self CheckConnection];
    if ((isConnect==YES)&&(isGo==YES)) {
        [self ReadGyro];
    }
    [self UpdateAppearance];
}


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
    
    isGo = NO;
    isConnect = YES;
    
    MotionManager = ([[CMMotionManager alloc]init]);
    MotionManager.deviceMotionUpdateInterval = 1/60;
    [MotionManager startDeviceMotionUpdates];
    
    RepeatTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(Running) userInfo:nil repeats:YES];	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
