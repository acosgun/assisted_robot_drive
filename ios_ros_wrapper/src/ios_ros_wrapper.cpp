//STL
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <vector>

//UDP 3rd Party
#include "PracticalSocket.h" // For UDPSocket and SocketException

//ROS
#include <ros/ros.h>
#include <ios_ros_wrapper/PhoneState.h>




const int ECHOMAX = 255;     // Longest string to echo



class IosRosWrapper
{

protected:
  ros::NodeHandle n_;

public:
  UDPSocket sock;
  ros::Publisher phoneState_pub_;

  IosRosWrapper (): n_("~"), sock(7575)
  {
    phoneState_pub_ = n_.advertise<ios_ros_wrapper::PhoneState>("/phone_state",1);
  }
  void receive_and_publish_data()
  {
      char echoBuffer[ECHOMAX];         // Buffer for echo string
      int recvMsgSize;                  // Size of received message
      string sourceAddress;             // Address of datagram source
      unsigned short sourcePort;        // Port of datagram source


      recvMsgSize = sock.recvFrom(echoBuffer, ECHOMAX, sourceAddress,sourcePort);
      unsigned int buffer_location = 0;

      vector<float> data;
      int mode=(int)echoBuffer[buffer_location];      
      
      buffer_location= buffer_location+1;
      

      for(unsigned int i=buffer_location; i<recvMsgSize; i++)
	{
	  float f1;
	  memcpy(&f1, echoBuffer+i, sizeof(float));
	  data.push_back(f1);
	  //cout<<"f1: "<<f1<<endl;	
	  i=i+3;
	}
      
      //Fill in ROS message
      ios_ros_wrapper::PhoneState msg;
      msg.header.stamp = ros::Time::now();
      msg.mode = mode;      
      msg.roll = data[0];
      msg.pitch = data[1];
      msg.heading = data[2];
      if(data.size() > 3)
	{
	  msg.speed_setting = data[3];
	}
      phoneState_pub_.publish(msg);
  }
  
};

int main (int argc, char** argv)
{
  ros::init(argc, argv, "IosRosWrapper");
  IosRosWrapper wrapper;
  ros::Rate loop_rate(2000.0);
  while(ros::ok())
    {
      wrapper.receive_and_publish_data();   
      ros::spinOnce();
      loop_rate.sleep();
    }
  return 0;
}
