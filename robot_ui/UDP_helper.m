//
//  UDP_helper.m
//  robot_ui
//
//  Created by Kaya Demir, Akansel Cosgun, Arnold Maliki on 3/23/14.
//  Copyright (c) 2014 Kaya Demir, Akansel Cosgun, Arnold Maliki. All rights reserved.
//

#import "UDP_helper.h"

@implementation UDP_helper{
    NSString *ip_;
    int p_;
    int sock;
    struct sockaddr_in destination;
    unsigned int echolen;
    int broadcast;     //char broadcast = '1';

}

- (id)init {
    if(self = [super init]){
        broadcast = 1;
    }
    return self;
}

-(bool) initializeSocket:(NSString *)ip port:(int)p
{
    if (ip == nil)
    {
        printf("Ip address is null\n");
        return false;
    }
    
    /* Create the UDP socket */
    if ((sock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP)) < 0)
    {
        printf("Failed to create socket\n");      return false;
    }
    
    /* Construct the server sockaddr_in structure */
    memset(&destination, 0, sizeof(destination));
    
    /* Clear struct */
    destination.sin_family = AF_INET;
    
    /* Internet/IP */
    destination.sin_addr.s_addr = inet_addr([ip UTF8String]);
    
    /* IP address */
    destination.sin_port = htons(p);
    
    /* server port */
    setsockopt(sock,
               IPPROTO_IP,
               IP_MULTICAST_IF,
               &destination,
               sizeof(destination));
    
    
    
    // this call is what allows broadcast packets to be sent:
    if (setsockopt(sock,
                   SOL_SOCKET,
                   SO_BROADCAST,
                   &broadcast,
                   sizeof broadcast) == -1)
    {
        perror("setsockopt (SO_BROADCAST)");
        exit(1);
    }
    
    return true;
}



-(bool) send:(NSMutableData*) data
{
    if (data == nil)
    {
        printf("Message is null\n");
        return false;
    }
    NSInteger data_length = [data length];
    char out_msg[(int)data_length];
    
    const char *data_bytes = [data bytes];
    
    for (int i=0; i<(int)data_length; i++)
    {
        out_msg[i]=data_bytes[i];
        //NSLog(@"Byte %d: %d", i, (int) data_bytes[i]);
    }
    echolen = sizeof(out_msg) / sizeof(out_msg[0]);
    //NSLog(@"Sending..");
    
    if (sendto(sock,
               out_msg,
               echolen,
               0,
               (struct sockaddr *) &destination,
               sizeof(destination)) != echolen)
    {
        NSLog(@"Mismatch in number of sent bytes");
        return false;
    }
    else
    {
        //NSLog([NSString stringWithFormat:@"-> Tx: %@",(NSString*) msg]);
        return true;
    }

    //close(sock);
}
@end