(in-package :stash)

(defvar *user*
  (make-instance 'user
                 :login "login"
                 :handle "Haru6aTop"
                 :password (string->hash "TpyCuKu")))

(setf (slot-value *user* 'stash.model::|_id|) 0)

(defun install-routes (app)
  (setf (ningle:route app "/")
        #'stash.views::main-page)
  (setf (ningle:route app "/login")
        #'stash.views::login-page)
  (setf (ningle:route app "/login" :method :post)
        (make-login-controller app))
  (setf (ningle:route app "/logout")
        (make-logout-controller app))
  (setf (ningle:route app "/newentry")
        (logged-in-only #'stash.views::newentry))
  (setf (ningle:route app "/newentry" :method :post)
        (logged-in-only (make-new-post-controller app)))
  (setf (ningle:route app "/hello/:name")
        #'stash.views::hello-page))

(defun generate-css ()
  (generate-general-css))

(defun print-hash (hash)
  (loop
     for k being the hash-key of hash
       using (hash-value v) do (format t "~A ~A~%" k v)))

;;; HARDCODE DEVELOPMENT
(defvar *source-location* (current-file-location))
(defvar *server* nil)

(defun start ()
  (setf *default-pathname-defaults* *source-location*)
  (generate-css)
  (setf (cl-who:html-mode) :html5)
  (let ((app (make-instance 'ningle:<app>))
        (config (load-config-from-file #P"default-config.lisp")))
    (install-routes app)
    (clack:clackup
     (lack:builder
      :session
      (:static
       :path "/static/"
       :root (merge-pathnames (static-path config)
                              (or *source-location* ; development setting
                                  (root-path config))))
      app))))

(defun start-server (&key (reload-stash nil))
  (when *server*
    (stop-server *server*))
  (when reload-stash
    (ql:quickload :stash))
  (setf *server* (start)))

(defun stop-server ()
  (clack:stop *server*))
