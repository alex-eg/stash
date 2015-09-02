(in-package :stash)

(defun install-routes (app)
  (setf (ningle:route app "/")
        #'stash.views::main-page)
  (setf (ningle:route app "/login")
        #'stash.views::login-page)
  (setf (ningle:route app "/logout")
        #'logout))

(defun logout (params)
  ())

(defun print-hash (hash)
  (loop
     for k being the hash-key of hash
       using (hash-value v) do (format t "~A ~A~%" k v)))

(defun start ()
  (setf (cl-who:html-mode) :html5)
  (let ((app (make-instance 'ningle:<app>)))
    (install-routes app)
    (clack:clackup
     (lack:builder :session
                   app))))
