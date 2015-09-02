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
               :cl-who
               :mongo-cl-driver)
  :components
  ((:file "user")
   (:file "post")
   (:file "diary")))
