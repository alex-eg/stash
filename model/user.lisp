(in-package :stash.model)

(defclass user (mongo-storable)
  ((login :initarg :login :accessor user-login)
   (email :initarg :email)
   (handle :initarg :handle)            ; alternative to login. shown name
   (password :initarg :password :accessor user-password)
   (friend-list :initarg :friend-list)))
