(in-package :cl-user)

(asdf:defsystem :stash
  :depends-on (:ningle
               :ironclad
               :flexi-streams
               :simple-date
               :cl-markdown
               :cl-ppcre
               :mongo-cl-driver)
  :components
  ((:file "user")
   (:file "post")
   (:file "diary")))
