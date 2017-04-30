(in-package :stash.model)

(deftable user ()
  (login :type text :uniquep t)
  (email :type text :uniquep t)
  (handle :type text :uniquep t)            ; alternative to login. shown name
  (password :type text)
  (adminp :type int))

(defun user-authorizedp (password user)
  (string= (string->hash password)
           (password user)))

(defun user-adminp (user)
  (adminp user))
