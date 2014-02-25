//
//  ViewController.h
//  RoboTracking
//
//  Created by Arnold Maliki on 2/23/14.
//  Copyright (c) 2014 Arnold Maliki. All rights reserved.
//

#import <UIKit/UIKit.h>

float counter = 1;

@interface ViewController : UIViewController
{
    IBOutlet UIImageView * Welcome;
    IBOutlet UIImageView * Image1;
    IBOutlet UIImageView * Image2;
    IBOutlet UIImageView * Image3;
    IBOutlet UIButton * NextButton;
    IBOutlet UILabel *SlideLabel;
    
    NSTimer * Timer1;
    
}

-(IBAction)GoNext:(id)sender;
-(void)UpdateAppearance;

@end
