(in-package :stash.model)

(defun string->hash (string)
  (ironclad:byte-array-to-hex-string
   (ironclad:digest-sequence
    :sha256
    (flexi-streams:string-to-octets string))))

(defclass user (mongo-storable)
  ((login :initarg :login :accessor user-login)
   (email :initarg :email)
   (handle :initarg :handle)            ; alternative to login. shown name
   (password :initarg :password :accessor user-password)
   (friend-list :initarg :friend-list)))
