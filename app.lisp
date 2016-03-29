(in-package :stash)

(defmacro compile-templates (template-list)
  (let ((defparameter-list
         (mapcar (lambda (sym)
                   `(defparameter
                        ,(intern (format nil "+~A+" sym) :stash)
                      (djula:compile-template*
                       ,(string-downcase (symbol-name sym)))))
                 template-list)))
    `(progn ,@defparameter-list)))

(lucerne:defapp app
    :middlewares
  (clack.middleware.session:<clack-middleware-session>
   (clack.middleware.static:<clack-middleware-static>
    :path "/static/"
    :root (relative-path #P"static/"))))

(defvar *swank-started* nil)
(defun start-swank ()
  (let ((swank:*use-dedicated-output-stream* nil))
    (swank:create-server :coding-system "utf-8-unix"
                         :dont-close t
                         :port 4008))
  (setq *swank-started* t))

(defun start-server ()
  (lucerne:start app))

(defun stop-server ()
  (lucerne:stop app))

(defun start-app (&key (deploy nil) (reload-system nil))
  (when reload-system
    (ql:quickload :stash))
  (when deploy
    (deploy))
  (unless *swank-started*
    (start-swank))
  (init-config (relative-path #P"conf.lisp"))
  (stop-server)
  (start-server))
