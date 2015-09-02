(in-package :stash.model)

(defun string->hash (string)
  (ironclad:byte-array-to-hex-string
   (ironclad:digest-sequence
    :sha256
    (flexi-streams:string-to-octets string))))

(defclass user (mongo-storable)
  ((name :initarg :name)
   (email :initarg :email)
   (handle :initarg :handle)
   (password :initarg :password)
   (friend-list :initarg :friend-list)))
