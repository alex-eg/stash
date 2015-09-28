(in-package :stash)

(defvar *user*
  (make-instance 'user
                 :login "login"
                 :handle "Haru6aTop"
                 :password (string->hash "TpyCuKu")))

(defun install-routes (app)
  (setf (ningle:route app "/")
        #'stash.views::main-page)
  (setf (ningle:route app "/login")
        #'stash.views::login-page)
  (setf (ningle:route app "/login" :method :post)
        #'(lambda (params)
            (let ((login (cdr (assoc "login" params :test #'string=)))
                  (password (cdr (assoc "password" params :test #'string=)))
                  (user *user*))
              (if (and (string= (user-login user) login)
                       (string= (string->hash password)
                                (user-password user)))
                  (progn
                    (let ((s (gethash :session ningle:*context*)))
                      (setf (gethash :authorized s) t))
                    "You're authorized! Hooray!")
                  "I don't know you. Go away."))))
  (setf (ningle:route app "/logout")
        #'logout)
  (setf (ningle:route app "/hello/:name")
        #'stash.views::hello-page))

(defun generate-css ()
  (generate-general-css))

(defun logout (params)
  ())

(defun print-hash (hash)
  (loop
     for k being the hash-key of hash
       using (hash-value v) do (format t "~A ~A~%" k v)))

;;; HARDCODE DEVELOPMENT
(eval-when (:compile-toplevel)
  (defparameter *source-location*
    (make-pathname
     :directory (pathname-directory *compile-file-truename*)
     :device (pathname-device *compile-file-truename*))))


(defun start ()
  (setf *default-pathname-defaults* *source-location*)
  (generate-css)
  (setf (cl-who:html-mode) :html5)
  (let ((app (make-instance 'ningle:<app>))
        (config (load-config-from-file #P"default-config.lisp")))
    (install-routes app)
    (clack:clackup
     (lack:builder :session
                   (:static
                    :path "/static/"
                    :root (merge-pathnames (static-path config)
                                           (or *source-location* ; development setting
                                               (root-path config))))
                   app))))
