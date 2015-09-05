(in-package :cl-user)

(defpackage :stash-test-asdf
  (:use :cl :asdf))

(in-package :stash-test-asdf)

(defsystem :stash-test
  :depends-on (:stash
               :prove)

  :defsystem-depends-on (:prove-asdf)

  :components
  ((:module "t"
            :serial t
            :components
            ((:file "package")
             (:test-file "mongo"))))

  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run) :prove) c)))
