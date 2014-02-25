//
//  ViewController.m
//  RoboTracking
//
//  Created by Arnold Maliki on 2/23/14.
//  Copyright (c) 2014 Arnold Maliki. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


-(IBAction)GoNext:(id)sender{
    counter = counter + 1;
    NextButton.hidden = YES;
    Image3.hidden = NO;
    [self UpdateAppearance];
    Image2.hidden = YES;
    Image2 = nil;
    Image1.hidden = YES;
    Image1 = nil;
}


-(void)UpdateAppearance{
    if (counter == 1) {
        SlideLabel.hidden = NO;
        Welcome.hidden = YES;
        Welcome = nil;
        Image1.animationImages = [NSArray arrayWithObjects:
                                   [UIImage imageNamed:@"still.png"],
                                   [UIImage imageNamed:@"up.png"],
                                   [UIImage imageNamed:@"still.png"],
                                   [UIImage imageNamed:@"up.png"],
                                   [UIImage imageNamed:@"still.png"],
                                   [UIImage imageNamed:@"down.png"],
                                   [UIImage imageNamed:@"still.png"],
                                   [UIImage imageNamed:@"down.png"],
                                  [UIImage imageNamed:@"still.png"],
                                  [UIImage imageNamed:@"right.png"],
                                  [UIImage imageNamed:@"still.png"],
                                  [UIImage imageNamed:@"right.png"],
                                  [UIImage imageNamed:@"still.png"],
                                  [UIImage imageNamed:@"left.png"],
                                  [UIImage imageNamed:@"still.png"],
                                  [UIImage imageNamed:@"left.png"],nil];
        [Image1 setAnimationRepeatCount:3];
        Image1.animationDuration = 8;
        [Image1 startAnimating];
        
        Image2.animationImages = [NSArray arrayWithObjects:
                                  [UIImage imageNamed:@"still2.png"],
                                  [UIImage imageNamed:@"up2.png"],
                                  [UIImage imageNamed:@"still2.png"],
                                  [UIImage imageNamed:@"up2.png"],
                                  [UIImage imageNamed:@"still2.png"],
                                  [UIImage imageNamed:@"down2.png"],
                                  [UIImage imageNamed:@"still2.png"],
                                  [UIImage imageNamed:@"down2.png"],
                                  [UIImage imageNamed:@"still2.png"],
                                  [UIImage imageNamed:@"right2.png"],
                                  [UIImage imageNamed:@"still2.png"],
                                  [UIImage imageNamed:@"right2.png"],
                                  [UIImage imageNamed:@"still2.png"],
                                  [UIImage imageNamed:@"left2.png"],
                                  [UIImage imageNamed:@"still2.png"],
                                  [UIImage imageNamed:@"left2.png"],nil];
        [Image2 setAnimationRepeatCount:3];
        Image2.animationDuration = 8;
        [Image2 startAnimating];

        
        
        NextButton.hidden = NO;
    }
    else {
        Image3.animationImages = [NSArray arrayWithObjects:
                                  [UIImage imageNamed:@"speedanddistance.png"],
                                  [UIImage imageNamed:@"redlinesandnumber.png"],
                                  [UIImage imageNamed:@"robotcolor.png"],
                                  [UIImage imageNamed:@"runandstop.png"],
                                  [UIImage imageNamed:@"yelarrow.png"],nil];
        [Image3 setAnimationRepeatCount:3];
        Image3.animationDuration = 8;
        [Image3 startAnimating];
        
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    NextButton.hidden = YES;
	SlideLabel.hidden = YES;
    Image3.hidden = YES;
    
    Welcome.animationImages = [NSArray arrayWithObjects:
                               [UIImage imageNamed:@"1.png"],
                               [UIImage imageNamed:@"2.png"],
                               [UIImage imageNamed:@"3.png"],
                               [UIImage imageNamed:@"4.png"],
                               [UIImage imageNamed:@"5.png"],
                               [UIImage imageNamed:@"6.png"],
                               [UIImage imageNamed:@"7.png"],
                               [UIImage imageNamed:@"8.png"],
                               [UIImage imageNamed:@"9.png"],
                               [UIImage imageNamed:@"10.png"],
                               [UIImage imageNamed:@"11.png"],
                               [UIImage imageNamed:@"12.png"],
                               [UIImage imageNamed:@"13.png"],
                               [UIImage imageNamed:@"14.png"],
                               [UIImage imageNamed:@"15.png"],
                               [UIImage imageNamed:@"16.png"],
                               [UIImage imageNamed:@"17.png"],
                               [UIImage imageNamed:@"18.png"],
                               [UIImage imageNamed:@"19.png"],nil];
    [Welcome setAnimationRepeatCount:1];
    Welcome.animationDuration = 0.7;
    [Welcome startAnimating];
    
    Timer1 = [NSTimer scheduledTimerWithTimeInterval:1.8 target:self selector:@selector(UpdateAppearance) userInfo:nil repeats:NO];
   // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
