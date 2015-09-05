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

  :depends-on (:ningle
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
               :mongo-cl-driver))
