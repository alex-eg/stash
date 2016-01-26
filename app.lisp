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
        #'stash.views::hello-page)
  (setf (ningle:route app "/posts")
        #'stash.views::posts-list-page)
  (setf (ningle:route app "/posts" :method :post)
        (make-new-post-controller app))
  (setf (ningle:route app "/update-settings")
        #'stash.views::admin-page)
  (setf (ningle:route app "/update-settings" :method :post)
        (make-admin-controller app))
  (setf (ningle:route app "/paste/create")
        #'stash.views::create-paste-page)
  (setf (ningle:route app "/paste/create" :method :post)
        (make-paste-controller app))
  (setf (ningle:route app "/paste/*")
        #'stash.views::show-paste-page)
  (setf (ningle:route app "/script")
        #'stash.views::simple-script))

(defun generate-css ()
  (generate-general-css)
  (generate-pygments-css "tango"))

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
    (stop-server))
  (when reload-stash
    (ql:quickload :stash))
  (setf *server* (start)))

(defun stop-server ()
  (clack:stop *server*)
  (setf *server* nil))
