//STL
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <vector>

//ROS
#include <ros/ros.h>
#include <ios_ros_wrapper/PhoneState.h>
#include <geometry_msgs/Twist.h>

class HumanCentricRemoteControl
{

protected:
  ros::NodeHandle n_;
  ros::Subscriber phoneState_sub_;
  ros::Publisher cmd_vel_pub_;

public:
  HumanCentricRemoteControl(): n_("~")
  {
    phoneState_sub_ = n_.subscribe<ios_ros_wrapper::PhoneState>("/phone_state",1, boost::bind(&HumanCentricRemoteControl::phoneStateCallback, this, _1));
    cmd_vel_pub_=n_.advertise<geometry_msgs::Twist>("cmd_vel",1000);
  }

  void phoneStateCallback(const ios_ros_wrapper::PhoneState::ConstPtr& msg)
  {
    int mode = (int) msg->mode;
    float roll = msg->roll;
    float pitch = msg->pitch;
    float heading = msg->heading;
    float speed_setting = msg->speed_setting;

    if(mode == 1) //Users device, not HC
      {
	
      }
    else if(mode == 101) //Users device, HC
      {

      }
    else if(mode == 0 || mode == 100) //Robots device
      {
	
      }    

    //ROS_INFO("Rcvd!");
  }

  void sendVelocity(double v,double w)
  {
    geometry_msgs::Twist vel_msg;
    vel_msg.linear.x=v;
    vel_msg.angular.z=w;
    cmd_vel_pub_.publish(vel_msg);
  }

  void stopRobot()
  {
    sendVelocity(0.0,0.0);
  }
  
  
};


int main (int argc, char** argv)
{
  ros::init(argc, argv, "HumanCentricRemoteControl");
  HumanCentricRemoteControl human_centric_rem;
  ros::spin();
  return 1;
}
