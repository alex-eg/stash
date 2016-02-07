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
             (:file "post")
             (:file "paste")))

   (:module "static"
            :depends-on ("packages")
            :components
            ((:file "css")))

   (:file "utils")
   (:file "packages")
   (:file "deploy")
   (:file "app")
   (:file "controllers"))

  :in-order-to ((test-op (test-op stash-test)))

  :depends-on (:lucerne
               :lucerne-auth
               :alexandria
               :split-sequence
               :anaphora
               :ironclad
               :flexi-streams
               :uiop
               :clack
               :lack
               :cl-json
               :cl-markdown
               :cl-ppcre
               :closer-mop
               :djula
               :lass                    ; css generation
               :parenscript             ; javascript
               :mongo-cl-driver.usocket))
