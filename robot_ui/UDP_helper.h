//
//  UDP_helper.h
//  robot_ui
//
//  Created by Akansel Cosgun on 3/23/14.
//  Copyright (c) 2014 Akansel Cosgun. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <arpa/inet.h>

@interface UDP_helper : NSObject
//- (void) setPlaying:(BOOL)in_playing;
//-(bool) send:(NSMutableData*) data ipAddress:(NSString*) ip port:(int) p;
-(bool) send:(NSMutableData*) data;
-(bool) initializeSocket:(NSString*) ip port:(int) p;
@end
