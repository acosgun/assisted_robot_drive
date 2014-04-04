//STL
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <vector>
//#include <mutex>
//#include <boost/thread/locks.hpp>
#include <boost/signals2/mutex.hpp>

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
  ios_ros_wrapper::PhoneState user_phone_state;
  ios_ros_wrapper::PhoneState robot_phone_state;
  ros::Timer control_timer;
  double control_frequency;
  boost::signals2::mutex phone_state_mtx;
  double angle_threshold_for_angular;
  double vel_linear_max;
  double vel_angular_max;
  double min_mag_to_move;
  double const_vel_window;

public:
  HumanCentricRemoteControl(): n_("~")
  {
    n_.param("control_frequency", control_frequency, 10.0);
    n_.param("angle_threshold_for_angular",angle_threshold_for_angular, 70.0);
    n_.param("vel_linear_max", vel_linear_max, 0.2);
    n_.param("vel_angular_max", vel_angular_max, 0.1);
    n_.param("min_mag_to_move", min_mag_to_move, 0.2);
    n_.param("const_vel_window",const_vel_window, 15.0);


    phoneState_sub_ = n_.subscribe<ios_ros_wrapper::PhoneState>("/phone_state",1, boost::bind(&HumanCentricRemoteControl::phoneStateCallback, this, _1));
    cmd_vel_pub_=n_.advertise<geometry_msgs::Twist>("/cmd_vel",1000);
    control_timer = n_.createTimer(ros::Duration(1.0/control_frequency), boost::bind(&HumanCentricRemoteControl::controlTimerCallback, this, _1));
  }

  void controlTimerCallback(const ros::TimerEvent& e)
  {    
    //get latest phone states
    //phone_state_mtx.lock();
    float roll = user_phone_state.roll;
    float pitch = user_phone_state.pitch;
    float heading = user_phone_state.heading;
    float speed_setting = user_phone_state.speed_setting;
    float robot_heading = robot_phone_state.heading;
    bool human_centric = false;
    if(user_phone_state.mode == 101)
      {
	human_centric = true;
      }
    //phone_state_mtx.unlock();


    double vel_linear = 0.0; double vel_angular = 0.0; double x = 0.0; double y = 0.0;


    findXYfromRP(pitch, roll, x, y);


    double mag = sqrt(x*x+y*y);
    double phase = atan2(y,x) *180/M_PI;
    
    //alter phase variable
    if(human_centric)
      {

      }


    computeVelocityFromDesiredDirection(mag,phase,vel_linear,vel_angular);
    sendVelocity(vel_linear,vel_angular);
    //    stopRobot();
    //ROS_INFO("x: %1.2f, y: %1.2f",x,y);
    //ROS_INFO("Mag: %1.2f, Phase: %1.2f",mag,phase);

    //ROS_INFO("R: %1.2f, P: %1.2f",roll,pitch);
    //ROS_INFO("v: %1.2f, w: %1.2f",vel_linear,vel_angular);    
  }


  void findXYfromRP(double pitch, double roll, double &x, double &y)
  {
   x = -pitch/90.0;
   y = -roll/90.0;

    if(x > 1.0)
      x = 1.0;
    if(x <-1.0)
      x =-1.0;
    if(y > 1.0)
      y = 1.0;
    if(y <-1.0)
      y=-1.0;
    return;
  }

  void computeVelocityFromDesiredDirection(double mag,double phase,double &vel_linear,double &vel_angular)
  {
    if(mag < min_mag_to_move)
      {
	vel_linear = 0.0;
	vel_angular = 0.0;
	return;
      }    

    if(phase > 90-const_vel_window && phase < 90+const_vel_window) //FW
      {
	vel_linear = vel_linear_max;
	vel_angular =0;
      }
    else if(phase > -90-const_vel_window && phase < -90+const_vel_window) //BW
      {
	vel_linear = -vel_linear_max;
	vel_angular =0;
      }
    else if(phase > -const_vel_window && phase < const_vel_window) //Turn R
      {
	vel_linear = 0;
	vel_angular = -vel_angular_max;
      }
    else if((phase > 180-const_vel_window && phase <= 180) || (phase >= -180 && phase < -180+const_vel_window)) // Turn L
      {
	vel_linear = 0;
	vel_angular = vel_angular_max;
      }
    else if (phase > 0) 
      {
	vel_linear = vel_linear_max;
	vel_angular = -vel_angular_max*cos(phase*M_PI/180.0);
      }
    else //phase < 0
      {
	vel_linear = -vel_linear_max;
	vel_angular = vel_angular_max*cos(phase*M_PI/180.0);
      }
    return;
  }

  void phoneStateCallback(const ios_ros_wrapper::PhoneState::ConstPtr& msg)
  {
    //phone_state_mtx.lock();
    //ROS_INFO("RAW R: %1.2f, P: %1.2f", msg->roll, msg->pitch);
    int mode = (int) msg->mode;
    if(mode == 1 || mode == 101) // User's device, 101 is HC
      {
	user_phone_state = *msg;
      }
    else if(mode == 0 || mode == 100) //Robots device
      {
	robot_phone_state = *msg;
      }    
    //phone_state_mtx.unlock();

    //ROS_INFO("Rcvd!");
    return;
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
