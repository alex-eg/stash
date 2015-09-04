(in-package :cl-user)

(asdf:defsystem :stash
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
               :mongo-cl-driver.usocket)
  :components ((:file "packages")
               (:file "model")
               (:file "user")
               (:file "post")
               (:file "view")
               (:file "header")
               (:file "main-page")
               (:file "app")))
