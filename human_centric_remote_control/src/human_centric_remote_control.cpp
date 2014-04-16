//STL
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <boost/signals2/mutex.hpp>

//ROS
#include <ros/ros.h>
#include <ios_ros_wrapper/PhoneState.h>
#include <geometry_msgs/Twist.h>
#include <sensor_msgs/LaserScan.h>
#include <sensor_msgs/PointCloud.h>
#include <laser_geometry/laser_geometry.h>

//PCL
#include <pcl/filters/voxel_grid.h>
#include <pcl/point_types.h>
#include <pcl/conversions.h>

class HumanCentricRemoteControl
{

protected:
  ros::NodeHandle n_;
  ros::Subscriber phoneState_sub_;
  ros::Subscriber laser_sub_;
  ros::Publisher cmd_vel_pub_;
  ios_ros_wrapper::PhoneState user_phone_state;
  ios_ros_wrapper::PhoneState robot_phone_state;
  //sensor_msgs::LaserScan last_scan;
  
  sensor_msgs::PointCloud laser_cloud;

  ros::Timer control_timer;
  double control_frequency;
  boost::signals2::mutex phone_state_mtx;
  boost::signals2::mutex laser_scan_mtx;
  laser_geometry::LaserProjection projector_;  
  double angle_threshold_for_angular;
  double vel_linear_max;
  double vel_angular_max;
  double min_mag_to_move;
  double const_vel_window;
  double t_robot_tolerance;
  bool obstacle_avoidance;
  double sim_time;
  double robot_radius;

public:
  HumanCentricRemoteControl(): n_("~")
  {
    n_.param("control_frequency", control_frequency, 10.0);
    n_.param("angle_threshold_for_angular",angle_threshold_for_angular, 70.0);
    n_.param("vel_linear_max", vel_linear_max, 0.2);
    n_.param("vel_angular_max", vel_angular_max, 0.1);
    n_.param("min_mag_to_move", min_mag_to_move, 0.2);
    n_.param("const_vel_window",const_vel_window, 15.0);
    n_.param("t_robot_tolerance",t_robot_tolerance, 0.2);
    n_.param("obstacle_avoidance",obstacle_avoidance, false);
    n_.param("sim_time",sim_time, 0.5);
    n_.param("robot_radius",robot_radius, 0.25);

    phoneState_sub_ = n_.subscribe<ios_ros_wrapper::PhoneState>("/phone_state",1, boost::bind(&HumanCentricRemoteControl::phoneStateCallback, this, _1));
    laser_sub_ = n_.subscribe<sensor_msgs::LaserScan>("/scan",1,boost::bind(&HumanCentricRemoteControl::LaserCallback,this,_1));

    cmd_vel_pub_=n_.advertise<geometry_msgs::Twist>("/cmd_vel",1);
    control_timer = n_.createTimer(ros::Duration(1.0/control_frequency), boost::bind(&HumanCentricRemoteControl::controlTimerCallback, this, _1));
  }

  void LaserCallback(const sensor_msgs::LaserScanConstPtr &scan_msg)
  {
    //ROS_INFO("Laser");
    laser_scan_mtx.lock();
    //last_scan = *scan_msg;
    projector_.projectLaser(*scan_msg, laser_cloud, 2.0);
    laser_scan_mtx.unlock();
  }

  void controlTimerCallback(const ros::TimerEvent& e)
  {    
    //get latest phone states
    //phone_state_mtx.lock();
    float roll = user_phone_state.roll;
    float pitch = user_phone_state.pitch;
    float user_heading = user_phone_state.heading;
    float speed_setting = user_phone_state.speed_setting; // TODO:send speed from app
    float robot_heading = robot_phone_state.heading;
    bool human_centric = false;
    if(user_phone_state.mode == 101)
      {
	human_centric = true;
      }
    //phone_state_mtx.unlock();


    ros::Time t_now_user = ros::Time::now();
    ros::Time t_last_user = user_phone_state.header.stamp;
    double t_diff_user = (t_now_user - t_last_user).toSec();

    if(t_diff_user > t_robot_tolerance) // good to go
      {
	ROS_INFO("No input");
	stopRobot();
	return;
      }


    double vel_linear = 0.0; double vel_angular = 0.0; double x = 0.0; double y = 0.0;


    findXYfromRP(pitch, roll, x, y);


    double mag = sqrt(x*x+y*y);
    double phase = atan2(y,x) *180/M_PI;
    
    //alter phase variable
    if(human_centric)
      {
	ros::Time t_now = ros::Time::now();
	ros::Time t_last_robot = robot_phone_state.header.stamp;
	double t_diff = (t_now - t_last_robot).toSec();
	//ROS_INFO("t_diff: %2.3f",t_diff);
	double phase_offset = 0.0;
	if(t_diff < t_robot_tolerance) // good to go
	  {
	    phase_offset = user_heading - robot_heading;
	    phase = phase - phase_offset
;

	    ROS_INFO("Phase Offset: %3.1f, New: %3.1f",phase_offset,phase);
	  }
      }


    computeVelocityFromDesiredDirection(mag,phase,vel_linear,vel_angular,human_centric);

    if(obstacle_avoidance && (vel_linear > 0) )
      {
	applyObstacleAvoidance(vel_linear,vel_angular,phase);
      }

    sendVelocity(vel_linear,vel_angular);

    //    stopRobot();
    //ROS_INFO("x: %1.2f, y: %1.2f",x,y);
    //ROS_INFO("Mag: %1.2f, Phase: %1.2f",mag,phase);

    //ROS_INFO("R: %1.2f, P: %1.2f",roll,pitch);
    //ROS_INFO("v: %1.2f, w: %1.2f",vel_linear,vel_angular);    
  }


  void applyObstacleAvoidance(double &vel_linear, double &vel_angular, double phase)
  {
    double x_out; double y_out;
    double w = vel_angular;        
    
    double dw = 0.03;
    int max_increment = 10;

    for (int increment = 0; increment < max_increment; increment++)
      {
	double cw_w = w + dw*increment;
	simulateTrajectory(0.0,0.0,M_PI/2,vel_linear,cw_w,sim_time,x_out,y_out);
	double cw_dist_to_obs = getClosestObstacle(x_out,y_out,phase);
	if(cw_dist_to_obs > robot_radius)
	  {
	    vel_angular = cw_w;
	    break;
	  }
	
	if(increment == 0)
	  continue;

	double ccw_w = w - dw*increment;
	simulateTrajectory(0.0,0.0,M_PI/2,vel_linear,ccw_w,sim_time,x_out,y_out);
	double ccw_dist_to_obs = getClosestObstacle(x_out,y_out,phase);
	if(ccw_dist_to_obs > robot_radius)
	  {
	    vel_angular = ccw_w;
	    break;
	  }
      }

    ROS_INFO("NO PATH!");
    vel_angular = 0.0;
    vel_linear  = 0.0;
    return;
  }

  double getClosestObstacle(double x, double y, double phase)
  {
    double dist=99.0;
    laser_scan_mtx.lock();
    for (unsigned int i = 0; i< laser_cloud.points.size(); i++) // TODO: look only a portion
      {
	double x_laser = laser_cloud.points[i].x;
	double y_laser = laser_cloud.points[i].y;
	double d = (x - x_laser)*(x - x_laser)+(y - y_laser)*(y - y_laser);
	if (d<dist)
	  dist =d;
      }
    laser_scan_mtx.unlock();
    return sqrt(dist);
  }
  

  void simulateTrajectory(double x, double y, double theta, double vx, double vtheta, double dt, double& x_out, double& y_out)
  {
    if(vtheta!=0)
      {
	double radius=vx/vtheta;
	x_out = x - radius * sin(theta) + radius * sin(theta + vtheta*dt);
	y_out = y + radius * cos(theta) - radius * cos(theta + vtheta*dt);
	//theta_out=theta + vtheta*dt;
	return;
      }
    else
      {
	x_out = x + vx * cos(theta)*dt;
	y_out = y + vx * sin(theta)*dt;
	//theta_out=theta;
	return;
      }
  }

  void computeVelocityFromDesiredDirection(double mag,double phase,double &vel_linear,double &vel_angular,bool human_centric)
  {
    if(mag < min_mag_to_move)
      {
	vel_linear = 0.0;
	vel_angular = 0.0;
	return;
      }    

    
    //if(human_centric)
      if(false)
      {
	if(phase > 90-const_vel_window && phase < 90+const_vel_window) //Forward
	  {
	    vel_linear = vel_linear_max;
	    vel_angular =0;
	    return;
	  }
	else if(phase < const_vel_window && phase >= -90) //TURN R
	  {
	    vel_linear = 0;
	    vel_angular = -vel_angular_max;
	  }
	else if((phase < -90 && phase >= -180) || (phase <= 180 && phase >=180-const_vel_window)) //TURN L
	  {
	    vel_linear = 0;
	    vel_angular = vel_angular_max;	    
	  }
	else //in between, FW
	  {
	    vel_linear = vel_linear_max;
	    vel_angular = -vel_angular_max*cos(phase*M_PI/180.0);
	  }
	return;
	
      }
    else
      {
	if(phase > 90-const_vel_window && phase < 90+const_vel_window) //Forward
	  {
	    vel_linear = vel_linear_max;
	    vel_angular =0;
	  }
	else if(phase > -90-const_vel_window && phase < -90+const_vel_window) //Backward
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
	else if (phase > 0) //in between
	  {
	    vel_linear = vel_linear_max;
	    vel_angular = -vel_angular_max*cos(phase*M_PI/180.0);
	  }
	else //in between phase < 0
	  {
	    vel_linear = -vel_linear_max;
	    vel_angular = vel_angular_max*cos(phase*M_PI/180.0);
	  }
	return;
      }

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
    
    if(x>0.7 || x<-0.7) // to cope with more than 90 deg
      {
      y = 0;
      //ROS_INFO("OVERBoard. x: %2.2f, y: %2.2f",x,y);
      }
      

    return;
  }


  
};


int main (int argc, char** argv)
{
  ros::init(argc, argv, "HumanCentricRemoteControl");
  HumanCentricRemoteControl human_centric_rem;
  ros::spin();
  return 1;
}
