(in-package :stash.model)

(defclass user (mongo-storable)
  ((collection :initform "users")
   (login :initarg :login :accessor user-login)
   (email :initarg :email)
   (handle :initarg :handle)            ; alternative to login. shown name
   (password :initarg :password :accessor user-password)
   (friend-list :initarg :friend-list)))

(defun user-authorized-p (password user)
  (string= (string->hash password)
           (user-password user)))
