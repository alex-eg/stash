(in-package :stash.model)

(defclass user (mongo-storable)
  ((collection :initform "users")
   (login :initarg :login :accessor user-login)
   (email :initarg :email :accessor user-email)
   (handle :initarg :handle :accessor user-handle)            ; alternative to login. shown name
   (password :initarg :password :accessor user-password)
   (adminp :initarg :adminp :initform nil :reader adminp)
   (friend-list :initarg :friend-list))
  (:metaclass mongo-storable-meta))

(defun user-authorizedp (password user)
  (string= (string->hash password)
           (user-password user)))

(defun user-adminp (user)
  (adminp user))
