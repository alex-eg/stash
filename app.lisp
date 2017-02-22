(in-package :stash)

(lucerne:defapp app
    :middlewares
  (clack.middleware.session:<clack-middleware-session>
   (clack.middleware.static:<clack-middleware-static>
    :path "/static/"
    :root (relative-path #P"static/"))))

(defun compile-templates ()
  (djula:add-template-directory (relative-path #P"views/"))
  (compile-templates% (head.html
                       base.html
                       main-page.html
                       script-page.html
                       posts.html
                       login.html

                       paste.html
                       create-paste.html

                       admin.html
                       add-user.html
                       settings.html)))

(defvar *swank-started* nil)
(defun start-swank ()
  (let ((swank:*use-dedicated-output-stream* nil))
    (swank:create-server :dont-close t
                         :port 4008))
  (setq *swank-started* t))

(defun start-server ()
  (lucerne:start app))

(defun stop-server ()
  (lucerne:stop app))

(defun start-app (&key (deploy nil) (reload-system nil)
                    (start-swank nil))
  (when reload-system
    (ql:quickload :stash))
  (init-config (relative-path #P"conf.lisp"))
  (compile-templates)
  (when deploy
    (deploy))
  (when start-swank
    (unless *swank-started*
      (start-swank)))
  (stop-server)
  (start-server))
