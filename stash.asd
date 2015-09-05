(in-package :cl-user)

(asdf:defsystem :stash
  :components
  ((:module "model"
            :components
            ((:file "model")
             (:file "user")
             (:file "post")))

   (:module "views"
            :components
            ((:file "view")
             (:file "header")
             (:file "main-page")))

   (:file "packages")
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
