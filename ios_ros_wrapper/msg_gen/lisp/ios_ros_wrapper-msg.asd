
(cl:in-package :asdf)

(defsystem "ios_ros_wrapper-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :std_msgs-msg
)
  :components ((:file "_package")
    (:file "PhoneState" :depends-on ("_package_PhoneState"))
    (:file "_package_PhoneState" :depends-on ("_package"))
  ))