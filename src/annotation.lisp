(in-package #:webapp)

(defclass user ()
  ((name
    :initarg :name
    :col-type string
    :accessor user-name)
   (email
    :initarg :email
    :col-type string
    :accessor user-email))
  (:metaclass dao-class)
  (:keys email))

(defclass annotation ()
  ((user
    :initarg :user
    :col-type )))
