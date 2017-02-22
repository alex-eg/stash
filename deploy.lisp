(in-package :stash)

(defmacro compile-templates% (template-list)
  (let ((defparameter-list
         (mapcar (lambda (sym)
                   `(defparameter
                        ,(intern (format nil "+~A+" sym) :stash)
                      (djula:compile-template*
                       ,(string-downcase (symbol-name sym)))))
                 template-list)))
    `(progn ,@defparameter-list)))

(defun generate-css ()
  (generate-general-css #P"static/main.css")
  (generate-pygments-css "tango" #P"static/pygments.css"))

(defun initialize-database ()
  (with-database (db "stash")
    (create-index (make-instance 'user)
                  (plist->hash (list "login" 1))
                  db)

    (create-index (make-instance 'paste)
                  (plist->hash (list "hash" 1))
                  db)))

(defun deploy ()
  "Copy files, write paths, initialize database with initial
user data"
  (generate-css)
  (download-jquery #P"static/jquery.js")
  (initialize-database)
  (with-database (db "stash")
    (let ((initial-user (config-get :initial-user)))
      (store-one
       (make-instance 'user
                      :login (config-get :login initial-user)
                      :handle (config-get :handle initial-user)
                      :adminp (config-get :adminp initial-user)
                      :password (string->hash
                                 (config-get :password initial-user)))
       db))))
