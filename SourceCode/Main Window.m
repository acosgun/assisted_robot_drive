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

-(void)empty {

    
}

-(IBAction)Start:(id)sender{
    if (isGo == NO) {
        [Start setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
        isGo = YES;
        currentLoop = 0;
        [self CheckConnection];
        if (isConnect==YES){
            if (currentDistance<2){
                [self Vibrate];
            }
        }
    }
    else {
        [Start setImage:[UIImage imageNamed:@"run.png"] forState:UIControlStateNormal];
        isGo = NO;
    }
    
}


-(IBAction)Connection:(id)sender{
    isGo = NO;
    currentLoop = 0;
}


-(void)CheckConnection{
    //ping and obtain data
    
    //if there is a response = connect,
    //obtain data: speed and distance to the wall.
    
    
    
    currentSpeed = 1;
    currentDistance = 3;
    actualAngle = 4*M_PI/2;
    
    IPAddress = @"192.168.1.1";
    
    
}

-(void)ReadGyro{
    CMAttitude * Attitude;
    CMDeviceMotion *motion = MotionManager.deviceMotion;
    Attitude = motion.attitude;
    
    currentRoll = degrees(Attitude.pitch);
    currentTilt = degrees(Attitude.roll);

    
    currentAngle = atan2f(currentTilt,currentRoll);
    actualAngle = currentAngle;
    NSLog(@"%f", currentAngle);

    
    
    
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
        VibrateOn = NO;
        UIImage *img = [UIImage imageNamed:@"robotgreen.png"];
        Robot.image = img;
        [Distance setTextColor:color];
    }
    
    else if ((currentDistance <= 2) && (currentDistance > 1)) {
        VibrateOn = YES;
        VibrateInterval = 25;
        UIImage *img = [UIImage imageNamed:@"robotred1.png"];
        Robot.image = img;
        UIColor *color = [UIColor colorWithRed:255/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
        [Distance setTextColor:color];
        
    }
    
    else if((currentDistance <= 1) && (currentDistance > 0.5)) {
        VibrateOn = YES;
        VibrateInterval = 10;
        UIImage *img = [UIImage imageNamed:@"robotred3.png"];
        Robot.image = img;
        UIColor *color = [UIColor colorWithRed:255/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
        [Distance setTextColor:color];
    }
    
    else if (currentDistance <= 0.5) {
        VibrateOn = YES;
        VibrateInterval = 5;
        UIImage *img = [UIImage imageNamed:@"robotred5.png"];
        [Robot setImage:img];
        UIColor *color = [UIColor colorWithRed:255/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
        [Distance setTextColor:color];
    }
    
    if ((currentDistance < 2) && (VibrateOn==YES)&&(isGo==YES)) {
        currentLoop = currentLoop+1;
        if (currentLoop >= VibrateInterval) {
            [self Vibrate];
            currentLoop = 0;
        }
        
    }
    
    
    CGAffineTransform yrotate =CGAffineTransformMakeRotation(M_PI/2-currentAngle);
    CGAffineTransform rrotate =CGAffineTransformMakeRotation(M_PI/2-actualAngle);
    CGAffineTransform ytranslation = CGAffineTransformMakeTranslation(yellowrad*cosf(currentAngle), -yellowrad*sinf(currentAngle));
    CGAffineTransform rtranslation = CGAffineTransformMakeTranslation(redrad*cosf(actualAngle),-redrad*sinf(actualAngle));
    Moving.transform = CGAffineTransformConcat(yrotate, ytranslation);
    //RedLine.transform = yrotate;
    //Speed2.transform = yrotate;
    RedLine.transform = CGAffineTransformConcat(rrotate, rtranslation);
    Speed2.transform = CGAffineTransformConcat(rrotate, rtranslation);
    
    
    
    //appear and disappear
    if ((isGo == NO) || ((fabsf(currentRoll) <= 1) && (fabsf(currentTilt) <= 1))) {
        Moving.hidden = YES;
    }
    
    else {
        Moving.hidden = NO;
    }
    
    
    //update appearance connection
    if (isConnect==YES) {
        Status.text = @"Connected";
        IP.text = IPAddress;
        RedLine.hidden = NO;
        Speed2.hidden = NO;
    }
    
    else {
        Status.text = @"Disconnected";
        IP.text = @"N/A";
        RedLine.hidden = YES;
        Speed2.hidden = YES;
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
    yellowrad = 220;
    redrad = 260;
    isGo = NO;
    isConnect = YES;
    VibrateOn = NO;
    currentLoop = 0;
    
    Moving.hidden = YES;
    RedLine.hidden = YES;
    Speed2.hidden=YES;
    
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
