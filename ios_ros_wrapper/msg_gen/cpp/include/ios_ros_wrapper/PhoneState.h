/* Auto-generated by genmsg_cpp for file /home/acosgun/repos/assisted_robot_drive/ios_ros_wrapper/msg/PhoneState.msg */
#ifndef IOS_ROS_WRAPPER_MESSAGE_PHONESTATE_H
#define IOS_ROS_WRAPPER_MESSAGE_PHONESTATE_H
#include <string>
#include <vector>
#include <map>
#include <ostream>
#include "ros/serialization.h"
#include "ros/builtin_message_traits.h"
#include "ros/message_operations.h"
#include "ros/time.h"

#include "ros/macros.h"

#include "ros/assert.h"

#include "std_msgs/Header.h"

namespace ios_ros_wrapper
{
template <class ContainerAllocator>
struct PhoneState_ {
  typedef PhoneState_<ContainerAllocator> Type;

  PhoneState_()
  : header()
  , mode(0)
  , roll(0.0)
  , pitch(0.0)
  , heading(0.0)
  , speed_setting(0.0)
  {
  }

  PhoneState_(const ContainerAllocator& _alloc)
  : header(_alloc)
  , mode(0)
  , roll(0.0)
  , pitch(0.0)
  , heading(0.0)
  , speed_setting(0.0)
  {
  }

  typedef  ::std_msgs::Header_<ContainerAllocator>  _header_type;
   ::std_msgs::Header_<ContainerAllocator>  header;

  typedef int8_t _mode_type;
  int8_t mode;

  typedef float _roll_type;
  float roll;

  typedef float _pitch_type;
  float pitch;

  typedef float _heading_type;
  float heading;

  typedef float _speed_setting_type;
  float speed_setting;


  typedef boost::shared_ptr< ::ios_ros_wrapper::PhoneState_<ContainerAllocator> > Ptr;
  typedef boost::shared_ptr< ::ios_ros_wrapper::PhoneState_<ContainerAllocator>  const> ConstPtr;
  boost::shared_ptr<std::map<std::string, std::string> > __connection_header;
}; // struct PhoneState
typedef  ::ios_ros_wrapper::PhoneState_<std::allocator<void> > PhoneState;

typedef boost::shared_ptr< ::ios_ros_wrapper::PhoneState> PhoneStatePtr;
typedef boost::shared_ptr< ::ios_ros_wrapper::PhoneState const> PhoneStateConstPtr;


template<typename ContainerAllocator>
std::ostream& operator<<(std::ostream& s, const  ::ios_ros_wrapper::PhoneState_<ContainerAllocator> & v)
{
  ros::message_operations::Printer< ::ios_ros_wrapper::PhoneState_<ContainerAllocator> >::stream(s, "", v);
  return s;}

} // namespace ios_ros_wrapper

namespace ros
{
namespace message_traits
{
template<class ContainerAllocator> struct IsMessage< ::ios_ros_wrapper::PhoneState_<ContainerAllocator> > : public TrueType {};
template<class ContainerAllocator> struct IsMessage< ::ios_ros_wrapper::PhoneState_<ContainerAllocator>  const> : public TrueType {};
template<class ContainerAllocator>
struct MD5Sum< ::ios_ros_wrapper::PhoneState_<ContainerAllocator> > {
  static const char* value() 
  {
    return "dc1e472e86b7c0e22a6f0073789bb302";
  }

  static const char* value(const  ::ios_ros_wrapper::PhoneState_<ContainerAllocator> &) { return value(); } 
  static const uint64_t static_value1 = 0xdc1e472e86b7c0e2ULL;
  static const uint64_t static_value2 = 0x2a6f0073789bb302ULL;
};

template<class ContainerAllocator>
struct DataType< ::ios_ros_wrapper::PhoneState_<ContainerAllocator> > {
  static const char* value() 
  {
    return "ios_ros_wrapper/PhoneState";
  }

  static const char* value(const  ::ios_ros_wrapper::PhoneState_<ContainerAllocator> &) { return value(); } 
};

template<class ContainerAllocator>
struct Definition< ::ios_ros_wrapper::PhoneState_<ContainerAllocator> > {
  static const char* value() 
  {
    return "Header header\n\
int8 mode\n\
float32 roll\n\
float32 pitch\n\
float32 heading\n\
float32 speed_setting\n\
================================================================================\n\
MSG: std_msgs/Header\n\
# Standard metadata for higher-level stamped data types.\n\
# This is generally used to communicate timestamped data \n\
# in a particular coordinate frame.\n\
# \n\
# sequence ID: consecutively increasing ID \n\
uint32 seq\n\
#Two-integer timestamp that is expressed as:\n\
# * stamp.secs: seconds (stamp_secs) since epoch\n\
# * stamp.nsecs: nanoseconds since stamp_secs\n\
# time-handling sugar is provided by the client library\n\
time stamp\n\
#Frame this data is associated with\n\
# 0: no frame\n\
# 1: global frame\n\
string frame_id\n\
\n\
";
  }

  static const char* value(const  ::ios_ros_wrapper::PhoneState_<ContainerAllocator> &) { return value(); } 
};

template<class ContainerAllocator> struct HasHeader< ::ios_ros_wrapper::PhoneState_<ContainerAllocator> > : public TrueType {};
template<class ContainerAllocator> struct HasHeader< const ::ios_ros_wrapper::PhoneState_<ContainerAllocator> > : public TrueType {};
} // namespace message_traits
} // namespace ros

namespace ros
{
namespace serialization
{

template<class ContainerAllocator> struct Serializer< ::ios_ros_wrapper::PhoneState_<ContainerAllocator> >
{
  template<typename Stream, typename T> inline static void allInOne(Stream& stream, T m)
  {
    stream.next(m.header);
    stream.next(m.mode);
    stream.next(m.roll);
    stream.next(m.pitch);
    stream.next(m.heading);
    stream.next(m.speed_setting);
  }

  ROS_DECLARE_ALLINONE_SERIALIZER;
}; // struct PhoneState_
} // namespace serialization
} // namespace ros

namespace ros
{
namespace message_operations
{

template<class ContainerAllocator>
struct Printer< ::ios_ros_wrapper::PhoneState_<ContainerAllocator> >
{
  template<typename Stream> static void stream(Stream& s, const std::string& indent, const  ::ios_ros_wrapper::PhoneState_<ContainerAllocator> & v) 
  {
    s << indent << "header: ";
s << std::endl;
    Printer< ::std_msgs::Header_<ContainerAllocator> >::stream(s, indent + "  ", v.header);
    s << indent << "mode: ";
    Printer<int8_t>::stream(s, indent + "  ", v.mode);
    s << indent << "roll: ";
    Printer<float>::stream(s, indent + "  ", v.roll);
    s << indent << "pitch: ";
    Printer<float>::stream(s, indent + "  ", v.pitch);
    s << indent << "heading: ";
    Printer<float>::stream(s, indent + "  ", v.heading);
    s << indent << "speed_setting: ";
    Printer<float>::stream(s, indent + "  ", v.speed_setting);
  }
};


} // namespace message_operations
} // namespace ros

#endif // IOS_ROS_WRAPPER_MESSAGE_PHONESTATE_H

