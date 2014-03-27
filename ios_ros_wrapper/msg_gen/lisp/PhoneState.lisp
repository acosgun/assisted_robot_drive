; Auto-generated. Do not edit!


(cl:in-package ios_ros_wrapper-msg)


;//! \htmlinclude PhoneState.msg.html

(cl:defclass <PhoneState> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (mode
    :reader mode
    :initarg :mode
    :type cl:fixnum
    :initform 0)
   (roll
    :reader roll
    :initarg :roll
    :type cl:float
    :initform 0.0)
   (pitch
    :reader pitch
    :initarg :pitch
    :type cl:float
    :initform 0.0)
   (heading
    :reader heading
    :initarg :heading
    :type cl:float
    :initform 0.0)
   (speed_setting
    :reader speed_setting
    :initarg :speed_setting
    :type cl:float
    :initform 0.0))
)

(cl:defclass PhoneState (<PhoneState>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <PhoneState>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'PhoneState)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name ios_ros_wrapper-msg:<PhoneState> is deprecated: use ios_ros_wrapper-msg:PhoneState instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <PhoneState>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ios_ros_wrapper-msg:header-val is deprecated.  Use ios_ros_wrapper-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'mode-val :lambda-list '(m))
(cl:defmethod mode-val ((m <PhoneState>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ios_ros_wrapper-msg:mode-val is deprecated.  Use ios_ros_wrapper-msg:mode instead.")
  (mode m))

(cl:ensure-generic-function 'roll-val :lambda-list '(m))
(cl:defmethod roll-val ((m <PhoneState>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ios_ros_wrapper-msg:roll-val is deprecated.  Use ios_ros_wrapper-msg:roll instead.")
  (roll m))

(cl:ensure-generic-function 'pitch-val :lambda-list '(m))
(cl:defmethod pitch-val ((m <PhoneState>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ios_ros_wrapper-msg:pitch-val is deprecated.  Use ios_ros_wrapper-msg:pitch instead.")
  (pitch m))

(cl:ensure-generic-function 'heading-val :lambda-list '(m))
(cl:defmethod heading-val ((m <PhoneState>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ios_ros_wrapper-msg:heading-val is deprecated.  Use ios_ros_wrapper-msg:heading instead.")
  (heading m))

(cl:ensure-generic-function 'speed_setting-val :lambda-list '(m))
(cl:defmethod speed_setting-val ((m <PhoneState>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ios_ros_wrapper-msg:speed_setting-val is deprecated.  Use ios_ros_wrapper-msg:speed_setting instead.")
  (speed_setting m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <PhoneState>) ostream)
  "Serializes a message object of type '<PhoneState>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (cl:let* ((signed (cl:slot-value msg 'mode)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 256) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    )
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'roll))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'pitch))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'heading))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'speed_setting))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <PhoneState>) istream)
  "Deserializes a message object of type '<PhoneState>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'mode) (cl:if (cl:< unsigned 128) unsigned (cl:- unsigned 256))))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'roll) (roslisp-utils:decode-single-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'pitch) (roslisp-utils:decode-single-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'heading) (roslisp-utils:decode-single-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'speed_setting) (roslisp-utils:decode-single-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<PhoneState>)))
  "Returns string type for a message object of type '<PhoneState>"
  "ios_ros_wrapper/PhoneState")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'PhoneState)))
  "Returns string type for a message object of type 'PhoneState"
  "ios_ros_wrapper/PhoneState")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<PhoneState>)))
  "Returns md5sum for a message object of type '<PhoneState>"
  "dc1e472e86b7c0e22a6f0073789bb302")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'PhoneState)))
  "Returns md5sum for a message object of type 'PhoneState"
  "dc1e472e86b7c0e22a6f0073789bb302")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<PhoneState>)))
  "Returns full string definition for message of type '<PhoneState>"
  (cl:format cl:nil "Header header~%int8 mode~%float32 roll~%float32 pitch~%float32 heading~%float32 speed_setting~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'PhoneState)))
  "Returns full string definition for message of type 'PhoneState"
  (cl:format cl:nil "Header header~%int8 mode~%float32 roll~%float32 pitch~%float32 heading~%float32 speed_setting~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <PhoneState>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     1
     4
     4
     4
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <PhoneState>))
  "Converts a ROS message object to a list"
  (cl:list 'PhoneState
    (cl:cons ':header (header msg))
    (cl:cons ':mode (mode msg))
    (cl:cons ':roll (roll msg))
    (cl:cons ':pitch (pitch msg))
    (cl:cons ':heading (heading msg))
    (cl:cons ':speed_setting (speed_setting msg))
))
