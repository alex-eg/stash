(in-package :cl-user)

(defpackage :stash-asdf
  (:use :cl :asdf))
(in-package :stash-asdf)

(defsystem :stash
  :components
  ((:module "model"
            :depends-on ("packages")
            :components
            ((:file "model")
             (:file "user")
             (:file "config")
             (:file "post")))

   (:module "views"
            :depends-on ("packages")
            :components
            ((:file "view")
             (:file "header")
             (:file "login")
             (:file "newentry")
             (:file "hello")
             (:file "posts-list-page")
             (:file "main-page")))

   (:module "static"
            :depends-on ("packages")
            :components
            ((:file "css")))

   (:file "utils")
   (:file "controllers")
   (:file "packages")
   (:file "deploy")
   (:file "app"))

  :in-order-to ((test-op (test-op stash-test)))

  :depends-on (:ningle
               :alexandria
               :ironclad
               :flexi-streams
               :clack
               :lack
               :cl-markdown
               :cl-ppcre
               :closer-mop
               :cl-who                  ; html templating
               :lass                    ; css generation
               :parenscript             ; javascript
               :mongo-cl-driver.usocket))
